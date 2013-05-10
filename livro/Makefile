all: booklet_from_pdf

SRCDIR=../
DSTDIR=./

FORTUNES= $(SRCDIR)mario.geral $(SRCDIR)mario.gauchismos $(SRCDIR)mario.anagramas $(SRCDIR)mario.palindromos $(SRCDIR)mario.piadas $(SRCDIR)mario.computadores $(SRCDIR)mario.arteascii

BL_FRENTE='4:-3L@.7(21cm,0)+0L@.7(21cm,14.85cm)'
BL_VERSO='4:1L@.7(21cm,0)+-2L@.7(21cm,14.85cm)'

PSTOPS=pstops
PDFTOPS=pdftops
PSTOPDF=ps2pdf

tex: livro.py $(FORTUNES)
	./livro.py $(FORTUNES)
 
dvi: tex 
	latex $(DSTDIR)mario_fortunes-livro.tex
	latex $(DSTDIR)mario_fortunes-livro.tex
	latex $(DSTDIR)mario_fortunes-livro.tex

ps: dvi
	dvips -o $(DSTDIR)mario_fortunes-livro.ps $(DSTDIR)mario_fortunes-livro.dvi

booklet: ps
	$(PSTOPS) $(BL_FRENTE) $(DSTDIR)mario_fortunes-livro.ps $(DSTDIR)mario_fortunes-booklet-frente.ps
	$(PSTOPS) $(BL_VERSO) $(DSTDIR)mario_fortunes-livro.ps $(DSTDIR)mario_fortunes-booklet-verso.ps

clean:
	rm -f $(DSTDIR)mario_fortunes*.{tex,dvi,ps,toc,aux,idx,log,pdf}
	rm -f $(DSTDIR)texput.log
	rm -f $(DSTDIR)*~
	rm -f *~

pdf: tex 
	pdflatex $(DSTDIR)mario_fortunes-livro.tex
	pdflatex $(DSTDIR)mario_fortunes-livro.tex
	pdflatex $(DSTDIR)mario_fortunes-livro.tex

booklet_from_pdf: pdf
	$(PDFTOPS) -paper A4 $(DSTDIR)mario_fortunes-livro.pdf $(DSTDIR)mario_fortunes-livro.ps
	$(PSTOPS) $(BL_FRENTE) $(DSTDIR)mario_fortunes-livro.ps $(DSTDIR)mario_fortunes-booklet-frente.ps
	$(PSTOPS) $(BL_VERSO) $(DSTDIR)mario_fortunes-livro.ps $(DSTDIR)mario_fortunes-booklet-verso.ps
	$(PSTOPDF) -sPAPERSIZE=a4 $(DSTDIR)mario_fortunes-booklet-frente.ps $(DSTDIR)mario_fortunes-booklet-frente.pdf
	$(PSTOPDF) -sPAPERSIZE=a4 $(DSTDIR)mario_fortunes-booklet-verso.ps $(DSTDIR)mario_fortunes-booklet-verso.pdf


.PHONY: all clean tex dvi ps booklet pdf booklet_from_pdf