# replace-in-zipfile

Put a placeholder file into a zipfile and replace it later. Supports streaming!

You can use any filename for your placeholder file. The matching is performed using the filesize and the file's CRC32. (Yes, there's a chance of checksum collision here!)

A tool called `make-magic` is provided to create high entropy placeholder data.

## Command line usage

``` sh
# create a placeholder whith high entropy
make-magic 512 > data/magic
# and put it into a zipfile along with other files
echo "Stuff" > data/stuff
zip -r data data

# you can now replace the magic data with any other content
echo "HEY!" | replace-in-zipfile data.zip data/magic > unpack/new.zip

# Let's unpack the new zipfile to see if it worked!
cd unpack
unzip new.zip
cd data
cat magic # displays "Hey!"
```

## Javascript usage

``` js
const fs = require('fs')
const concat = require('concat-stream')
const replaceFileInzip = require('../replace-file-in-zip')

if (process.argv.length<4) {
  console.error(`usage: ${process.argv[1]} <zip-file> <magic-file>`)
  console.error('(data read from stdin will replace magic file data in the zip-file)')
  process.exit(1)
}

const zipFileName = process.argv[2]
const magicFileName = process.argv[3]

const magicData = fs.readFileSync(magicFileName)

process.stdin.pipe(concat(function (newContent) {
  fs.createReadStream(zipFileName)
    .pipe( replaceFileInzip(magicData, newContent) )
    .pipe(process.stdout)
}))
```
