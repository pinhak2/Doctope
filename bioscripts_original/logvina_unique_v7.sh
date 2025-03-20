#Este não é mais o logvina_cesup_v6, ele foi editado para se adequar a nova disposição dos logs do CESUP.
sed "s/^   1/IN_ log1  &/" log_1 > log1_1
grep -h IN_ log1_1 > OUT1
sed "s/^   2/OUT log1  &/" log_1 > log1_1
grep -h OUT log1_1 >> OUT1

sed "s/^   1/IN_ log2  &/" log_2 > log2_1
grep -h IN_ log2_1 > OUT2
sed "s/^   2/OUT log2  &/" log_2 > log2_1
grep -h OUT log2_1 >> OUT2

sed "s/^   1/IN_ log3  &/" log_3 > log3_1
grep -h IN_ log3_1 > OUT3
sed "s/^   2/OUT log3  &/" log_3 > log3_1
grep -h OUT log3_1 >> OUT3

sed "s/^   1/IN_ log4  &/" log_4 > log4_1
grep -h IN_ log4_1 > OUT4
sed "s/^   2/OUT log4  &/" log_4 > log4_1
grep -h OUT log4_1 >> OUT4

sed "s/^   1/IN_ log5  &/" log_5 > log5_1
grep -h IN_ log5_1 > OUT5
sed "s/^   2/OUT log5  &/" log_5 > log5_1
grep -h OUT log5_1 >> OUT5

sed "s/^   1/IN_ log6  &/" log_6 > log6_1
grep -h IN_ log6_1 > OUT6
sed "s/^   2/OUT log6  &/" log_6 > log6_1
grep -h OUT log6_1 >> OUT6

sed "s/^   1/IN_ log7  &/" log_7 > log7_1
grep -h IN_ log7_1 > OUT7
sed "s/^   2/OUT log7  &/" log_7 > log7_1
grep -h OUT log7_1 >> OUT7

sed "s/^   1/IN_ log8  &/" log_8 > log8_1
grep -h IN_ log8_1 > OUT8
sed "s/^   2/OUT log8  &/" log_8 > log8_1
grep -h OUT log8_1 >> OUT8

sed "s/^   1/IN_ log9  &/" log_9 > log9_1
grep -h IN_ log9_1 > OUT9
sed "s/^   2/OUT log9  &/" log_9 > log9_1
grep -h OUT log9_1 >> OUT9

sed "s/^   1/IN_ log10 &/" log_10 > log10_1
grep -h IN_ log10_1 > OUT10
sed "s/^   2/OUT log10 &/" log_10 > log10_1
grep -h OUT log10_1 >> OUT10

sed "s/^   1/IN_ log11 &/" log_11 > log11_1
grep -h IN_ log11_1 > OUT11
sed "s/^   2/OUT log11 &/" log_11 > log11_1
grep -h OUT log11_1 >> OUT11

sed "s/^   1/IN_ log12 &/" log_12 > log12_1
grep -h IN_ log12_1 > OUT12
sed "s/^   2/OUT log12 &/" log_12 > log12_1
grep -h OUT log12_1 >> OUT12

sed "s/^   1/IN_ log13 &/" log_13 > log13_1
grep -h IN_ log13_1 > OUT13
sed "s/^   2/OUT log13 &/" log_13 > log13_1
grep -h OUT log13_1 >> OUT13

sed "s/^   1/IN_ log14 &/" log_14 > log14_1
grep -h IN_ log14_1 > OUT14
sed "s/^   2/OUT log14 &/" log_14 > log14_1
grep -h OUT log14_1 >> OUT14

sed "s/^   1/IN_ log15 &/" log_15 > log15_1
grep -h IN_ log15_1 > OUT15
sed "s/^   2/OUT log15 &/" log_15 > log15_1
grep -h OUT log15_1 >> OUT15

sed "s/^   1/IN_ log16 &/" log_16 > log16_1
grep -h IN_ log16_1 > OUT16
sed "s/^   2/OUT log16 &/" log_16 > log16_1
grep -h OUT log16_1 >> OUT16

sed "s/^   1/IN_ log17 &/" log_17 > log17_1
grep -h IN_ log17_1 > OUT17
sed "s/^   2/OUT log17 &/" log_17 > log17_1
grep -h OUT log17_1 >> OUT17

sed "s/^   1/IN_ log18 &/" log_18 > log18_1
grep -h IN_ log18_1 > OUT18
sed "s/^   2/OUT log18 &/" log_18 > log18_1
grep -h OUT log18_1 >> OUT18

sed "s/^   1/IN_ log19 &/" log_19 > log19_1
grep -h IN_ log19_1 > OUT19
sed "s/^   2/OUT log19 &/" log_19 > log19_1
grep -h OUT log19_1 >> OUT19

sed "s/^   1/IN_ log20 &/" log_20 > log20_1
grep -h IN_ log20_1 > OUT20
sed "s/^   2/OUT log20 &/" log_20 > log20_1
grep -h OUT log20_1 >> OUT20

cat OUT1 OUT2 OUT3 OUT4 OUT5 OUT6 OUT7 OUT8 OUT9 OUT10 OUT11 OUT12 OUT13 OUT14 OUT15 OUT16 OUT17 OUT18 OUT19 OUT20 > EXCLUDED
mv log_1 Backup_log_1
rm log*_1 OUT*
mv Backup_log_1 log_1
