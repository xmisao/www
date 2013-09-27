---
layout: blog
title: partedでパフォーマンスの警告が出た場合の対処法
tag: linux
---

# partedでパフォーマンスの警告が出た場合の対処法

partedでパーティションを作っていると、以下の警告が出る場合がある。

~~~~
Warning: The resulting partition is not properly aligned for best performance.
~~~~

手元の環境では、GPTでディスク全体を使ったパーティションを作ろうとした時に、この警告が出た。
以下のように、セクタの開始位置を2048セクタにしてやったら、警告は出なくなった。

~~~~
(parted) mkpart primary 2048s -1s
~~~~

そもそもこの警告は何なのだろうか?

おそらくこのメッセージは、Advanced Format Technology(AFT)なる形式のハードディスクを意図したものだと思う。この形式のハードディスクでは、従来は512byteだった物理セクタが、4096byteに拡張されている。これはビッグセクタなどとも呼ばれている。

OSのI/Oの単位は一般に4096byteなので、4096byteの物理セクタを跨ぐようにパーティションを作成すると、I/Oの度に2つの物理セクタの読み書きが発生する。このためI/Oのパフォーマンスが低下するというやつだ。

それならば、4096 / 512 = 8セクタの倍数をパーティションの先頭にすれば、どのようなハードディスクでも、パフォーマンスは低下しないはずだ。ところが、以下のようにpartedで開始セクタを64セクタに指定してやっても、同様の警告が出る。

~~~~
(parted) mkpart primary 64s -1s
~~~~

partedのソースを確認すると、このメッセージの出力にあたって以下の判定がされているようだ。

ざっと読むと、`alignment`(これは-aオプションの指定が格納される変数)に応じて、`partition_align_check()`を行い、結果が偽なら警告を発するらしい。

~~~~
if ((alignment == ALIGNMENT_OPTIMAL &&
		 !partition_align_check(disk, part, PA_OPTIMUM)) ||
		(alignment == ALIGNMENT_MINIMAL &&
		 !partition_align_check(disk, part, PA_MINIMUM))) {
				if (ped_exception_throw(
								PED_EXCEPTION_WARNING,
								(opt_script_mode
								 ? PED_EXCEPTION_OK
								 : PED_EXCEPTION_IGNORE_CANCEL),
								_("The resulting partition is not properly "
									"aligned for best performance.")) ==
						PED_EXCEPTION_CANCEL) {
								/* undo partition addition */
								goto error_remove_part;
				}
}
~~~~

`partition_align_check()`の実装は以下のとおり。
コメントの通りなら、パーティションがディスクのオフセットとアライメントの要求に合致していれば真になるようだ。

~~~~
/* Return true if partition PART is consistent with DISK's selected
   offset and alignment requirements.  Also return true if there is
   insufficient kernel support to determine DISK's alignment requirements.
   Otherwise, return false.  A_TYPE selects whether to check for minimal
   or optimal alignment requirements.  */
static bool
partition_align_check (PedDisk const *disk, PedPartition const *part,
		       enum AlignmentType a_type)
{
  PED_ASSERT (part->disk == disk, return false);
  PedDevice const *dev = disk->dev;

  PedAlignment *pa = (a_type == PA_MINIMUM
		      ? ped_device_get_minimum_alignment (dev)
		      : ped_device_get_optimum_alignment (dev));
  if (pa == NULL)
    return true;

  PED_ASSERT (pa->grain_size != 0, return false);
  bool ok = (part->geom.start % pa->grain_size == pa->offset);
  free (pa);
  return ok;
}
~~~~

`PedAlignment`はディスクのアライメントに関する情報を格納した構造体だろうか。

`part->geom.start`(パーティションの開始位置か?)を`pa->grain_size`(粒の大きさ…物理セクタか何かのサイズか?)で割った余りが、`pa->offset`(よくわからない)と一致していれば真になるようだ。

と、ここまできて気力が萎えたので、深追いはしないことにする。

参考までに、`PedAlignment`構造体を取得している`ped_device_get_minimum_alignment()`と`ped_device_get_optinum_alignment()`の実装は以下のとおり。

~~~~
/**
 * Get an alignment that represents minimum hardware requirements on alignment.
 * When for example using media that has a physical sector size that is a
 * multiple of the logical sector size, it is desirable to have disk accesses
 * (and thus partitions) properly aligned. Having partitions not aligned to
 * the minimum hardware requirements may lead to a performance penalty.
 *
 * The returned alignment describes the alignment for the start sector of the
 * partition, the end sector should be aligned too, to get the end sector
 * alignment decrease the returned alignment's offset by 1.
 *
 * \return the minimum alignment of partition start sectors, or NULL if this
 *         information is not available.
 */
PedAlignment*
ped_device_get_minimum_alignment(const PedDevice *dev)
{
        PedAlignment *align = NULL;

        if (ped_architecture->dev_ops->get_minimum_alignment)
                align = ped_architecture->dev_ops->get_minimum_alignment(dev);

        if (align == NULL)
                align = ped_alignment_new(0,
                                dev->phys_sector_size / dev->sector_size);

        return align;
}

/**
 * Get an alignment that represents the hardware requirements for optimal
 * performance.
 *
 * The returned alignment describes the alignment for the start sector of the
 * partition, the end sector should be aligned too, to get the end sector
 * alignment decrease the returned alignment's offset by 1.
 *
 * \return the optimal alignment of partition start sectors, or NULL if this
 *         information is not available.
 */
PedAlignment*
ped_device_get_optimum_alignment(const PedDevice *dev)
{
        PedAlignment *align = NULL;

        if (ped_architecture->dev_ops->get_optimum_alignment)
                align = ped_architecture->dev_ops->get_optimum_alignment(dev);

        /* If the arch specific code could not give as an alignment
           return a default value based on the type of device. */
        if (align == NULL) {
                switch (dev->type) {
                case PED_DEVICE_DASD:
                        align = ped_device_get_minimum_alignment(dev);
                        break;
                default:
                        /* Align to a grain of 1MiB (like vista / win7) */
                        align = ped_alignment_new(0,
                                                  1048576 / dev->sector_size);
                }
        }

        return align;
}
~~~~

ともかく、partedが気に入るパラメータには、何やら複雑な条件があるようだ。
中途半端になってしまったが、このエントリはここで終わり。
