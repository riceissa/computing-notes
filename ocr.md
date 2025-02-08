# How to OCR a directory full of jpg images

```bash
cd directory_with_images/

# make sure all of the images are in order, with the cover image as the very first image
ls

# combine all the jpg files into a pdf
img2pdf *.jpg --output combined.pdf

# now OCR the pdf
ocrmypdf -l eng --rotate-pages --deskew --title "title of your book" combined.pdf combined_ocr.pdf 
```
