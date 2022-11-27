%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% asm-article.cls, v1.3, 2020/02/06
% Developed by Overleaf
%
% This class file enables authors to prepare
% manuscripts for submission to ASM.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{manuscript}[2020/02/06, v1.3]

%% Definitions for adding placeholder journal elements
\def\@jlogo{}
\def\@jname{}
\def\@jyear{}
\def\@jpages{}
\def\@jvolume{}
\def\@jissue{}
\def\@jwebsite{}

\def\@affil{}
\def\@runningauthor{}
\def\@runningtitle{}
\def\@corraddress{}
\def\@equalcontrib{}

\def\@papertype{Author Manuscript}
\def\@paperfield{}
\def\@paperdoi{}

\ProcessOptions\relax


\LoadClass[11pt]{article}

\sloppy

\newcommand{\jlogo}[1]{\def\@jlogo{#1}}
\newcommand{\jname}[1]{\def\@jname{#1}}
\newcommand{\jyear}[1]{\def\@jyear{#1}}
\newcommand{\jvolume}[1]{\def\@jvolume{#1}}
\newcommand{\jissue}[1]{\def\@jissue{#1}}
\newcommand{\jpages}[1]{\def\@jpages{#1}}
\newcommand{\jwebsite}[1]{\def\@jwebsite{#1}}

\newcommand{\runningauthor}[1]{\def\@runningauthor{#1}}
\newcommand{\runningtitle}[1]{\def\@runningtitle{#1}}
\newcommand{\corraddress}[1]{\def\@corraddress{#1}}
\newcommand{\equalcontrib}[1]{\def\@equalcontrib{#1}}


\newcommand{\paperdoi}[1]{\def\@paperdoi{#1}}
\newcommand{\papertype}[1]{\def\@papertype{#1}}
\newcommand{\paperfield}[1]{\def\@paperfield{#1}}


%% Fonts
\RequirePackage[T1]{fontenc}
\RequirePackage[utf8]{inputenc}
\RequirePackage{microtype}
\RequirePackage{fbb}
\RequirePackage[default,scale=0.82]{opensans}
\RequirePackage[scaled=0.82]{newtxsf}
\renewcommand{\ttdefault}{\sfdefault}

\RequirePackage{xpatch}
\RequirePackage{textcase}
\RequirePackage[table]{xcolor}
\RequirePackage{graphicx}
\RequirePackage{tikz,pgffor}
\RequirePackage{mdframed}
\RequirePackage{changepage}
\RequirePackage{enumitem}
\RequirePackage[mathlines]{lineno}

%% Colours
\definecolor{sectioncolor}{HTML}{00274C}

%% Page geometry
\RequirePackage[letterpaper,
left=0.6in,right=1in,
top=1in,bottom=0.6in,
columnsep=2em,headheight=12pt,
headsep=0.35in,footskip=0.25in,
marginparwidth=0in,marginparsep=0.2in,
includehead,includefoot,heightrounded,
]{geometry}

\newenvironment{fullwidth}{\begin{adjustwidth}{}{-2.35in}}{\end{adjustwidth}}

%% Title and author block

\RequirePackage{authblk}
\renewcommand\Authfont{\bfseries}
\renewcommand\Affilfont{\normalfont\scriptsize}
\setlength{\affilsep}{0.3em}
%\newcommand{\corrauthor}[2][]{\affil[#1]{Correspondence: #2}}
\renewcommand{\maketitle}{%
  \null\vskip2\baselineskip%
  {\noindent\bfseries\raggedright\huge\@title\par}
  \vskip2\baselineskip
  {\noindent\bfseries\raggedright\normalfont
  \@author
  \par}
  {\noindent\raggedright\scriptsize
  \@affil
  \par
  \ifdefstring{\@equalcontrib}{}{}{\@equalcontrib\par}}%
  \thispagestyle{firstpage}%
}


\newcommand{\infobox}{%
\begin{mdframed}%
[backgroundcolor=black!10,
 font=\scriptsize,
 hidealllines=true,
 innerleftmargin=1em,
 innerrightmargin=1em,
 innertopmargin=1em,
 innerbottommargin=1em]%
\setlength{\parskip}{0.5em}%
\textbf{Compiled} \today\\
%This is a draft manuscript, pre-submission\par
\textsuperscript{\textdagger}Correspondence: \@corraddress.\par
\end{mdframed}
}


%% Coloured abstract
\RequirePackage[runin]{abstract}
\setlength{\absleftindent}{0pt}
\setlength{\absrightindent}{0pt}
\setlength{\abstitleskip}{-\parindent}
\renewcommand{\abstractname}{ABSTRACT}
\renewcommand{\abstractnamefont}{\bfseries\color{sectioncolor}\scshape}
\renewcommand{\abstracttextfont}{\normalfont}
\abslabeldelim{\quad}
\appto\abstract{%
\newenvironment{importance}
  {\newline\noindent{\abstractnamefont IMPORTANCE}\@bslabeldelim}{}
}

\newcommand{\keywords}[1]{{\raggedright\textbf{\color{sectioncolor}KEYWORDS:}\hspace{0.3em}#1\par}\vspace{\baselineskip}}

%% Headers
\RequirePackage{fancyhdr}
\addtolength{\headwidth}{\marginparsep}
\addtolength{\headwidth}{\marginparwidth}
\renewcommand{\headrule}{}
\fancyhf{}
\lhead{\footnotesize{\@runningauthor}}
\rhead{\footnotesize{\@runningtitle}}
\lfoot{}
\rfoot{\footnotesize\@jwebsite\quad\textbf{\thepage}}
%\cfoot{%
%  \tikz[remember picture,overlay]
%  \node[transform shape,rotate=90,anchor=north,yshift=-6pt,text=gray] at (current page.west)
%  {\foreach \n in {1,...,10}{Author Manuscript Preprint \hspace{1em}}};
%}
\pagestyle{fancy}

\fancypagestyle{firstpage}{
  \pagestyle{fancy}%
  \lfoot{}%
  \lhead{}
  \rhead{%
    \textcolor{sectioncolor}{\bfseries\MakeUppercase{\@papertype}}\\%
    \@paperfield%
  }
}

%% Drop-cap
\RequirePackage{lettrine}
\renewcommand{\LettrineFontHook}{\bfseries\color{gray}}
\newcommand{\dropcap}[2][]{\lettrine[#1,nindent=0pt,lines=2,loversize=0.05]{#2}{}}

%% Sectional headings
\RequirePackage[explicit]{titlesec}
\titleformat{\section}
  {\bfseries\color{sectioncolor}}
  {}{0pt}{\MakeTextUppercase{#1}}
\titlespacing*{\section}{0pt}{\baselineskip}{0pt}
\titleformat{\subsection}[runin]
  {\bfseries}
  {}{0pt}{#1}
\titlespacing*{\subsection}
{\parindent}
{0pt}{0.3em}

%% Disable \subsubsection, \paragraph, \subparagraph
%\let\subsubsection\relax
%\let\paragraph\relax
%\let\subparagraph\relax

%% Citations and References (page-width, 2 columns)
\RequirePackage[numbers,round]{natbib}
\RequirePackage{multicol}
\RequirePackage[noperiod]{jabbrv}
\DefineJournalAbbreviation{National}{Natl}
%% Renamed vancouver-asm.bst to msystems.bst on 12 July, 2019
\bibliographystyle{msystems}
\renewcommand{\bibnumfmt}[1]{\makebox[1.5em][l]{#1.}}
\renewcommand{\bibfont}{\footnotesize}
\setlength{\bibsep}{0pt}
\renewcommand{\bibpreamble}{%
  \nolinenumbers%
  \setlength{\multicolsep}{0pt}
}
\preto{\endthebibliography}{}

%% Lists
\RequirePackage{enumitem}
\setlist{nosep,labelindent=\parindent}

%% Tables
\RequirePackage{booktabs}
\RequirePackage{tabularx}
\newcommand{\tnote}[1]{\textsuperscript{\textit{#1}}}
\newlist{tablenotes}{description}{1}
\setlist[tablenotes]{labelsep=0pt,format=\mdseries\itshape\textsuperscript}

% http://tex.stackexchange.com/a/266441/226
\newcommand*{\belowrulesepcolor}[1]{%
  \noalign{%
    \kern-\belowrulesep
    \begingroup
      \color{#1}%
      \hrule height\belowrulesep
    \endgroup
  }%
}
\newcommand*{\aboverulesepcolor}[1]{%
  \noalign{%
    \begingroup
      \color{#1}%
      \hrule height\aboverulesep
    \endgroup
    \kern-\aboverulesep
  }%
}
\colorlet{tableheadcolor}{black!20}
\newcommand{\headrow}{\rowcolor{tableheadcolor}}
\newcommand{\headrowfillerT}{\belowrulesepcolor{tableheadcolor}}
\newcommand{\headrowfillerB}{\aboverulesepcolor{tableheadcolor}}
\apptocmd{\tablenotes}{\footnotesize}{}{}

% Left-, right- and center-aligned auto-wrapping column types
\newcolumntype{L}{>{\raggedright\arraybackslash}X}
\newcolumntype{R}{>{\raggedleft\arraybackslash}X}
\newcolumntype{C}{>{\centering\arraybackslash}X}

%% Captions
\RequirePackage[singlelinecheck=false]{caption}
\renewcommand{\figurename}{FIG}
\renewcommand{\tablename}{TABLE}
\DeclareCaptionFont{eb}{\fontseries{eb}\selectfont}
\captionsetup*{labelsep=quad}
\captionsetup*[figure]{font={bf,small},labelfont={eb}}
\captionsetup*[table]{labelfont=bf,position=above,skip=0pt}

%% Enable coloured links
\RequirePackage[hyphens]{url}
\RequirePackage[colorlinks,allcolors=blue,breaklinks]{hyperref}
\urlstyle{same}
