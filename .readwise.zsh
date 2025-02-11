alias debug-build-readwise="cd '/Users/aarjav/Documents/rekindled/reading-clients/reader' && pnpm run desktop:build--debug"
alias build-readwise="cd '/Users/aarjav/Documents/rekindled/reading-clients/reader' && pnpm run desktop:build"

pdf_slice() {
  if [ $# -ne 4 ]; then
    echo "Usage: pdf_slice <input_pdf> <start_page> <end_page> <output_pdf>"
    echo "Example: pdf_slice input.pdf 1 10 output.pdf"
    return 1
  fi

  input_pdf="$1"
  start_page="$2"
  end_page="$3"
  output_pdf="$4"

  if [ ! -f "$input_pdf" ]; then
    echo "Error: Input PDF file '$input_pdf' not found."
    return 1
  fi

  if ! command -v pdftk &>/dev/null; then
    echo "Error: pdftk is not installed. Please install it first."
    return 1
  fi

  pdftk "$input_pdf" cat $start_page-$end_page output "$output_pdf"

  if [ $? -eq 0 ]; then
    echo "Successfully created '$output_pdf' with pages $start_page to $end_page from '$input_pdf'."
  else
    echo "Error: Failed to create the sliced PDF."
    return 1
  fi
}
