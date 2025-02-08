# How to OCR a directory full of jpg images

```bash
cd directory_with_images/

# make sure all of the images are in order, with the cover image as the very first image
ls

# combine all the jpg files into a pdf
img2pdf *.jpg --output combined.pdf

# now OCR the pdf
ocrmypdf -l eng --rotate-pages --deskew --title "title of your book - list of authors" combined.pdf combined_ocr.pdf 
```

WARNING: ocrmypdf can use up _a lot_ of space depending on how many pages are in the PDF.
It doesn't work in a "stream-like" way where each page is processed individually. Instead,
it creates tons of temporary files in `/tmp` or wherever and doesn't delete any of it
until the final PDF is ready.  You can set the tempdir using
`env TMPDIR=/location/of/temp/dir ocrmypdf ...`. However, on WSL this is tricky because
ocrmypdf tries to create symlinks so I couldn't set my `D:` drive to be the temp dir,
since the `D:` drive isn't part of the WSL filesystem so apprently WSL can't create
symlinks there.

Also after it OCRs every page, it can still spend a lot of time in the postprocessing and
linearizing steps. You can check using htop or pgrep something to make sure it's still working.
