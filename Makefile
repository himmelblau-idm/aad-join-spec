all: aad-join-spec.pdf

aad-join-spec.pdf: aad-join-spec.html
	google-chrome --headless --disable-gpu --no-sandbox --no-pdf-header-footer --print-to-pdf="$@" "file://$(CURDIR)/$<"

aad-join-spec.html: aad-join-spec.md
	pandoc --from=markdown_mmd -Vcss= -Vpagetitle="[MS-DRS] Device Registration Service" --standalone --to=html aad-join-spec.md >$@

clean:
	rm aad-join-spec.pdf aad-join-spec.html >/dev/null 2>&1 || echo
