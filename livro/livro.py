#!/usr/bin/env python

import sys

bverbatim = r'\begin{Verbatim}[fontfamily=times]'
bverbatimascii = r'\begin{Verbatim}[fontsize=\scriptsize]'
bminipage = r'\begin{minipage}{\textwidth}'
bverb = r'\begin{verbatim}'

header = r'''
\documentclass[brazil,twoside,a4paper,12pt]{book}
\usepackage[brazil]{babel}
\usepackage{indentfirst}
% #\usepackage[T1]{fontenc}
\usepackage[latin1]{inputenc}
\usepackage{fancyhdr}
\usepackage{fancyvrb}
\usepackage{url}
\usepackage{float}
\usepackage{afterpage}
\usepackage{amsfonts,amsmath,amssymb}
\usepackage{calc}

\makeindex

\begin{document}

\frontmatter
\newlength{\centeroffset}
\setlength{\centeroffset}{-0.5\oddsidemargin}
\addtolength{\centeroffset}{0.5\evensidemargin}
\thispagestyle{empty}
\vspace*{\stretch{1}}
\noindent\hspace*{\centeroffset}\makebox[0pt][l]{\begin{minipage}{\textwidth}
\flushleft
{\Huge\bfseries \texttt{mario\_fortunes}}
\noindent\rule[-1ex]{\textwidth}{5pt}\\[2.5ex]
\end{minipage}}

\vspace{\stretch{1}}
\noindent\hspace*{\centeroffset}\makebox[0pt][l]{\begin{minipage}{\textwidth}
\flushright
{\texttt{versão 0.20}\\\bfseries Mario Domenech Goulart}
\end{minipage}}

\vspace{\stretch{2}}
\newpage

\tableofcontents

\chapter*{Prefácio}
\VerbatimInput[fontfamily=times,fontshape=it]{../LEIAME}

\mainmatter

\newcommand{\separador}{\centering\huge$\sim\backsim$\vspace{10\lineskip}}
'''

tex_file = open('mario_fortunes-livro.tex', 'w')
tex_file.write(header)

for file in sys.argv[1:]:

    fortune_file = open(file, 'r')

    section_name = 'mario.' + file.split('.')[-1:][0]

    tex_file.write(r'\chapter{' + section_name + '}\n')
    tex_file.write(bminipage + '\n')

    print section_name
    if section_name == 'mario.arteascii':
        tex_file.write(bverbatimascii + '\n')
    elif section_name == 'mario.computadores':
        tex_file.write(bverb + '\n')
    else:
        tex_file.write(bverbatim + '\n')


    for line in fortune_file.readlines():
        if line == '%\n':

            if section_name == 'mario.computadores':
                tex_file.write(r'\end{verbatim}' + '\n')
            else:
                tex_file.write(r'\end{Verbatim}' + '\n')

            if section_name != 'mario.arteascii':
                tex_file.write(r'\separador' + '\n')

            tex_file.write(r'\end{minipage}' + '\n\n')
            tex_file.write(r'\afterpage{\clearpage}' + '\n')
            tex_file.write(bminipage + '\n')

            if section_name == 'mario.arteascii':
                tex_file.write(bverbatimascii + '\n')
            elif section_name == 'mario.computadores':
                tex_file.write(bverb + '\n')
            else:
                tex_file.write(bverbatim + '\n')

        else:
            if section_name == 'mario.anagramas':
                line = line.replace('<-->', ' :::: ')
            tex_file.write(line)

    if section_name == 'mario.computadores':
        tex_file.write('\n' + r'\end{verbatim}' + '\n' + r'\end{minipage}' + '\n')
    else:
        tex_file.write('\n' + r'\end{Verbatim}' + '\n' + r'\end{minipage}' + '\n')
    fortune_file.close()



tex_file.write(r'\chapter{Créditos}' + '\n\n')
tex_file.write(r'\VerbatimInput{../CREDITOS}' + '\n\n')

tex_file.write(r'\chapter{Licença}' + '\n\n')
tex_file.write(r'\fvset{fontsize=\small}' + '\n')
tex_file.write(r'\VerbatimInput{../LICENCA}' + '\n\n')

tex_file.write(r'\chapter{Histórico de modificações}' + '\n\n')
tex_file.write(r'\VerbatimInput{../CHANGELOG}' + '\n\n')

tex_file.write(r'\chapter{Dicas}' + '\n\n')
tex_file.write(r'\VerbatimInput{../DICAS}' + '\n\n')

tex_file.write(r'\chapter{\textit{Bugs}}' + '\n\n')
tex_file.write(r'\VerbatimInput{../BUGS}' + '\n\n')

tex_file.write(r'\end{document}' + '\n')

tex_file.close()
