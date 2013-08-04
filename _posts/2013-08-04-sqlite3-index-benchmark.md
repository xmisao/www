---
layout: default
title: SQLite3のインデックスのベンチマーク
---

# SQLite3のインデックスのベンチマーク

インデックスのつけ忘れで痛い目を見たので、SQLite3でインデックスの有無がどれほど参照性能に影響を与えるか、簡単なベンチマークをしてみた。

col0, col1, col2の3カラムから成るテーブルを作成し、3つの条件(1)インデックスなし、(2)col0カラムにインデックスあり、(3)col0, col1のマルチカラムインデックスありで、レコード数を10万件、100万件、1000万件と増やして、全9通りの条件でSELECT文の実行時間を測定して参照性能を調べた。スキーマを抜粋する。

    CREATE TABLE `table_100k_noindex` (`col0` integer, `col1` integer, `col2` varchar(255));
    CREATE TABLE `table_100k_index` (`col0` integer, `col1` integer, `col2` varchar(255));
    CREATE TABLE `table_100k_two_index` (`col0` integer, `col1` integer, `col2` varchar(255));
    CREATE INDEX `table_100k_index_col0_index` ON `table_100k_index` (`col0`);
    CREATE INDEX `table_100k_two_index_col0_col1_index` ON `table_100k_two_index` (`col0`, `col1`);

実行するSELECT文は、WHERE句とORDER BY句を含みLIMIT句で参照数を1万件に制限するクエリにした。WHERE句とORDER BY句で指定するカラムは、インデックスを作成したcol0とcol1カラムとして、対象のカラムを入れ替えた2通りでテストする。レコードのデータはランダムに生成し、WHERE句ではテーブル全体の1/2が絞り込まれるようにした。SELECT文の例を以下に示す。

    SELECT * FROM `table_100k_noindex` WHERE (`col0` <= 1073741824) ORDER BY `col1` LIMIT 10000;
    SELECT * FROM `table_100k_noindex` WHERE (`col1` <= 1073741824) ORDER BY `col0` LIMIT 10000;

ベンチマークの結果は以下の表のとおりになった。

<table class="table table-striped">
<tr><th rowspan="2">インデックス</th><th colspan="2" rowspan="2">クエリ</th><th colspan="3">レコード数</th></tr>
<tr><th>WHERE</th><th>ORDER BY</th><th>0.1M</th><th>1M</th><th>10M</th></tr>
<tr><td rowspan="2">なし</td><td>col0</td><td>col1</td>
<td>0.16</td>
<td>0.81</td>
<td>7.16</td>
</tr>
<tr><td>col1</td><td>col0</td>
<td>0.16</td>
<td>0.82</td>
<td>7.17</td>
</tr>
<tr><td rowspan="2">col0</td><td>col0</td><td>col1</td>
<td>0.21</td>
<td>1.85</td>
<td>21.83</td>
</tr>
<tr><td>col1</td><td>col0</td>
<td>0.09</td>
<td>0.12</td>
<td>0.14</td>
</tr>
<tr><td rowspan="2">col0, col1</td><td>col0</td><td>col1</td>
<td>0.21</td>
<td>1.85</td>
<td>21.94</td>
</tr>
<tr><td>col1</td><td>col0</td>
<td>0.09</td>
<td>0.10</td>
<td>0.11</td>
</tr>
</table>

1000万件のレコードを対象としたベンチマークでは、インデックスなしの7秒に対してマルチカラムインデックスを使った検索は0.1秒となり、70倍早くなった。ただし、ORDER BY句にインデックスが効かない場合は、インデックスありは21秒でインデックスなしの7秒と比べて3倍遅くなった。どちらも、レコード数の増加に伴って差が広がる傾向がわかる。

意外だったのは、1カラムのインデックスと、マルチカラムインデックスの条件で、差が約20%の高速化に留まったことだ。マルチカラムインデックスで、WHERE句にもインデックスが使えればもっと早くなると思ったが、この条件ではそうでもなかった。マルチカラムでソートすればまた違った結果が出たかもしれない。

## ソースコード

    require 'sequel'
    
    def create_database()
    	puts 'create_database()'
    
    	DB.create_table :table_100k_noindex do
    		Integer	:col0
    		Integer	:col1
    		String :col2
    	end
    
    	DB.create_table :table_100k_index do
    		Integer	:col0
    		Integer	:col1
    		String :col2
    		index :col0
    	end
    
    	DB.create_table :table_100k_two_index do
    		Integer	:col0
    		Integer	:col1
    		String :col2
    		index [:col0, :col1]
    	end
    
    	DB.create_table :table_1m_noindex do
    		Integer	:col0
    		Integer	:col1
    		String :col2
    	end
    
    	DB.create_table :table_1m_index do
    		Integer	:col0
    		Integer	:col1
    		String :col2
    		index :col0
    	end
    
    	DB.create_table :table_1m_two_index do
    		Integer	:col0
    		Integer	:col1
    		String :col2
    		index [:col0, :col1]
    	end
    
    	DB.create_table :table_10m_noindex do
    		Integer	:col0
    		Integer	:col1
    		String :col2
    	end
    
    	DB.create_table :table_10m_index do
    		Integer	:col0
    		Integer	:col1
    		String :col2
    		index :col0
    	end
    
    	DB.create_table :table_10m_two_index do
    		Integer	:col0
    		Integer	:col1
    		String :col2
    		index [:col0, :col1]
    	end
    end
    
    def generate_data()
    	puts 'generate_data()'
    
    	generate(DB[:table_100k_noindex], 100 * 1000)
    	generate(DB[:table_100k_index], 100 * 1000)
    	generate(DB[:table_100k_two_index], 100 * 1000)
    	generate(DB[:table_1m_noindex], 1000 * 1000)
    	generate(DB[:table_1m_index], 1000 * 1000)
    	generate(DB[:table_1m_two_index], 1000 * 1000)
    	generate(DB[:table_10m_noindex], 10000 * 1000)
    	generate(DB[:table_10m_index], 10000 * 1000)
    	generate(DB[:table_10m_two_index], 10000 * 1000)
    end
    
    def generate(table, count)
    	DB.transaction do
    		count.times{
    			table.insert(:col0 => rand(2 ** 31), :col1 => rand(2 ** 31), :col2 => ('a'..'z').to_a.shuffle[0..8].join)
    		}
    	end
    end
    
    def benchmark()
    	puts 'benchmark()'
    
    	search(DB[:table_100k_noindex])
    	search(DB[:table_100k_index])
    	search(DB[:table_100k_two_index])
    	search(DB[:table_1m_noindex])
    	search(DB[:table_1m_index])
    	search(DB[:table_1m_two_index])
    	search(DB[:table_10m_noindex])
    	search(DB[:table_10m_index])
    	search(DB[:table_10m_two_index])
    end
    
    def search(table)
    	query = table.where{col0 <= 2 ** 31 / 2}.order(:col1).limit(10000)
    	puts query.sql
    	bench do
    		query.each{}
    	end
    
    	query = table.where{col1 <= 2 ** 31 / 2}.order(:col0).limit(10000)
    	puts query.sql
    	bench do
    		query.each{}
    	end
    end
    
    def bench(&blk)
    	st = Time.now
    	10.times{
    		yield
    	}
    	ed = Time.now
    	STDERR.puts ((ed - st).to_f / 10).to_s
    end
    
    DB = Sequel.sqlite('DB')
    create_database()
    generate_data()
    benchmark()

## スキーマ

    CREATE TABLE `table_100k_index` (`col0` integer, `col1` integer, `col2` varchar(255));
    CREATE TABLE `table_100k_noindex` (`col0` integer, `col1` integer, `col2` varchar(255));
    CREATE TABLE `table_100k_two_index` (`col0` integer, `col1` integer, `col2` varchar(255));
    CREATE TABLE `table_10m_index` (`col0` integer, `col1` integer, `col2` varchar(255));
    CREATE TABLE `table_10m_noindex` (`col0` integer, `col1` integer, `col2` varchar(255));
    CREATE TABLE `table_10m_two_index` (`col0` integer, `col1` integer, `col2` varchar(255));
    CREATE TABLE `table_1m_index` (`col0` integer, `col1` integer, `col2` varchar(255));
    CREATE TABLE `table_1m_noindex` (`col0` integer, `col1` integer, `col2` varchar(255));
    CREATE TABLE `table_1m_two_index` (`col0` integer, `col1` integer, `col2` varchar(255));
    CREATE INDEX `table_100k_index_col0_index` ON `table_100k_index` (`col0`);
    CREATE INDEX `table_100k_two_index_col0_col1_index` ON `table_100k_two_index` (`col0`, `col1`);
    CREATE INDEX `table_10m_index_col0_index` ON `table_10m_index` (`col0`);
    CREATE INDEX `table_10m_two_index_col0_col1_index` ON `table_10m_two_index` (`col0`, `col1`);
    CREATE INDEX `table_1m_index_col0_index` ON `table_1m_index` (`col0`);
    CREATE INDEX `table_1m_two_index_col0_col1_index` ON `table_1m_two_index` (`col0`, `col1`);

## 全クエリとEXPLAIN QUERY PLANの結果

    SELECT * FROM `table_100k_noindex` WHERE (`col0` <= 1073741824) ORDER BY `col1`
    {:selectid=>0, :order=>0, :from=>0, :detail=>"SCAN TABLE table_100k_noindex (~333333 rows)"}
    {:selectid=>0, :order=>0, :from=>0, :detail=>"USE TEMP B-TREE FOR ORDER BY"}
    SELECT * FROM `table_100k_noindex` WHERE (`col1` <= 1073741824) ORDER BY `col0`
    {:selectid=>0, :order=>0, :from=>0, :detail=>"SCAN TABLE table_100k_noindex (~333333 rows)"}
    {:selectid=>0, :order=>0, :from=>0, :detail=>"USE TEMP B-TREE FOR ORDER BY"}
    SELECT * FROM `table_100k_index` WHERE (`col0` <= 1073741824) ORDER BY `col1`
    {:selectid=>0, :order=>0, :from=>0, :detail=>"SEARCH TABLE table_100k_index USING INDEX table_100k_index_col0_index (col0<?) (~250000 rows)"}
    {:selectid=>0, :order=>0, :from=>0, :detail=>"USE TEMP B-TREE FOR ORDER BY"}
    SELECT * FROM `table_100k_index` WHERE (`col1` <= 1073741824) ORDER BY `col0`
    {:selectid=>0, :order=>0, :from=>0, :detail=>"SCAN TABLE table_100k_index USING INDEX table_100k_index_col0_index (~333333 rows)"}
    SELECT * FROM `table_100k_two_index` WHERE (`col0` <= 1073741824) ORDER BY `col1`
    {:selectid=>0, :order=>0, :from=>0, :detail=>"SEARCH TABLE table_100k_two_index USING INDEX table_100k_two_index_col0_col1_index (col0<?) (~250000 rows)"}
    {:selectid=>0, :order=>0, :from=>0, :detail=>"USE TEMP B-TREE FOR ORDER BY"}
    SELECT * FROM `table_100k_two_index` WHERE (`col1` <= 1073741824) ORDER BY `col0`
    {:selectid=>0, :order=>0, :from=>0, :detail=>"SCAN TABLE table_100k_two_index USING INDEX table_100k_two_index_col0_col1_index (~333333 rows)"}
    SELECT * FROM `table_1m_noindex` WHERE (`col0` <= 1073741824) ORDER BY `col1`
    {:selectid=>0, :order=>0, :from=>0, :detail=>"SCAN TABLE table_1m_noindex (~333333 rows)"}
    {:selectid=>0, :order=>0, :from=>0, :detail=>"USE TEMP B-TREE FOR ORDER BY"}
    SELECT * FROM `table_1m_noindex` WHERE (`col1` <= 1073741824) ORDER BY `col0`
    {:selectid=>0, :order=>0, :from=>0, :detail=>"SCAN TABLE table_1m_noindex (~333333 rows)"}
    {:selectid=>0, :order=>0, :from=>0, :detail=>"USE TEMP B-TREE FOR ORDER BY"}
    SELECT * FROM `table_1m_index` WHERE (`col0` <= 1073741824) ORDER BY `col1`
    {:selectid=>0, :order=>0, :from=>0, :detail=>"SEARCH TABLE table_1m_index USING INDEX table_1m_index_col0_index (col0<?) (~250000 rows)"}
    {:selectid=>0, :order=>0, :from=>0, :detail=>"USE TEMP B-TREE FOR ORDER BY"}
    SELECT * FROM `table_1m_index` WHERE (`col1` <= 1073741824) ORDER BY `col0`
    {:selectid=>0, :order=>0, :from=>0, :detail=>"SCAN TABLE table_1m_index USING INDEX table_1m_index_col0_index (~333333 rows)"}
    SELECT * FROM `table_1m_two_index` WHERE (`col0` <= 1073741824) ORDER BY `col1`
    {:selectid=>0, :order=>0, :from=>0, :detail=>"SEARCH TABLE table_1m_two_index USING INDEX table_1m_two_index_col0_col1_index (col0<?) (~250000 rows)"}
    {:selectid=>0, :order=>0, :from=>0, :detail=>"USE TEMP B-TREE FOR ORDER BY"}
    SELECT * FROM `table_1m_two_index` WHERE (`col1` <= 1073741824) ORDER BY `col0`
    {:selectid=>0, :order=>0, :from=>0, :detail=>"SCAN TABLE table_1m_two_index USING INDEX table_1m_two_index_col0_col1_index (~333333 rows)"}
    SELECT * FROM `table_10m_noindex` WHERE (`col0` <= 1073741824) ORDER BY `col1`
    {:selectid=>0, :order=>0, :from=>0, :detail=>"SCAN TABLE table_10m_noindex (~333333 rows)"}
    {:selectid=>0, :order=>0, :from=>0, :detail=>"USE TEMP B-TREE FOR ORDER BY"}
    SELECT * FROM `table_10m_noindex` WHERE (`col1` <= 1073741824) ORDER BY `col0`
    {:selectid=>0, :order=>0, :from=>0, :detail=>"SCAN TABLE table_10m_noindex (~333333 rows)"}
    {:selectid=>0, :order=>0, :from=>0, :detail=>"USE TEMP B-TREE FOR ORDER BY"}
    SELECT * FROM `table_10m_index` WHERE (`col0` <= 1073741824) ORDER BY `col1`
    {:selectid=>0, :order=>0, :from=>0, :detail=>"SEARCH TABLE table_10m_index USING INDEX table_10m_index_col0_index (col0<?) (~250000 rows)"}
    {:selectid=>0, :order=>0, :from=>0, :detail=>"USE TEMP B-TREE FOR ORDER BY"}
    SELECT * FROM `table_10m_index` WHERE (`col1` <= 1073741824) ORDER BY `col0`
    {:selectid=>0, :order=>0, :from=>0, :detail=>"SCAN TABLE table_10m_index USING INDEX table_10m_index_col0_index (~333333 rows)"}
    SELECT * FROM `table_10m_two_index` WHERE (`col0` <= 1073741824) ORDER BY `col1`
    {:selectid=>0, :order=>0, :from=>0, :detail=>"SEARCH TABLE table_10m_two_index USING INDEX table_10m_two_index_col0_col1_index (col0<?) (~250000 rows)"}
    {:selectid=>0, :order=>0, :from=>0, :detail=>"USE TEMP B-TREE FOR ORDER BY"}
    SELECT * FROM `table_10m_two_index` WHERE (`col1` <= 1073741824) ORDER BY `col0`
    {:selectid=>0, :order=>0, :from=>0, :detail=>"SCAN TABLE table_10m_two_index USING INDEX table_10m_two_index_col0_col1_index (~333333 rows)"}
