rm -rf unpack/*
rm data.zip
../bin/make-magic 512 > data/magic
zip -r data data
echo "If you see this, it worked!" | ../bin/replace data.zip data/magic > unpack/new.zip
cd unpack
unzip new.zip
cd data
cat magic
cd ../..
