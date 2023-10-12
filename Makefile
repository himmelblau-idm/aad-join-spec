all: aad-join-spec.pdf

aad-join-spec.pdf: aad-join-spec.html
	# Requires wkhtmltopdf with patched qt
	wkhtmltopdf --footer-right "[page] / [topage]" --footer-left "Entra ID Device Registration Join Protocol" --footer-line --footer-font-name "Segoe UI" --footer-font-size 10 aad-join-spec.html aad-join-spec.pdf

aad-join-spec.html: aad-join-spec.md
	pandoc --from=markdown_mmd -Vcss= -Vpagetitle="Entra ID Device Registration Join Protocol" --standalone --to=html aad-join-spec.md >$@

clean:
	rm aad-join-spec.pdf aad-join-spec.html >/dev/null 2>&1 || echo
