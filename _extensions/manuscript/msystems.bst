%% msystems.bst updated on 19 January 2020 by Overleaf
%% to implement changes required by ASM. Among them,
%% three new entry types are defined: patent, 
%% dataset and confabstract. 
%%
%% RENAMED TO msystems.bst ON 12 JULY 2019,
%% following changes by Overleaf to
%% move publication year to after authors upon ASM
%% request. Also made author names bold.

%% vancouver-asm.bst (23 Aug 2017) is modified
%% by LianTze Lim (Overleaf)
%% from the
%% natbib-compatible BibTeX bibliography style `vancouver-authoryear' at  https://github.com/gbhutani/vancouver_authoryear_bibstyle/

%% Use
%%
%% \usepackage{natbib}
%% \bibliographystyle{vancouver-compatible}
%%
%% and cite references with (e.g.)
%%
%% \cite{smith77}       % to get a "[1]" in the text
%% \citep{smith77}      % to get a "[1]" in the text
%% \citet{smith77}      % to get a "Smith [1]" in the text
%% \citeauthor{smith77} % to get a "Smith" in the text
%%
%% The changes below are inspired by similar changes made to
%% splncs03.bst by Maurizio "Titto" Patrignani of
%% Dipartimento di Informatica e Automazione Universita' Roma Tre.
%% Unfortunately, splncs03.bst was not compatible with natbib (because it
%% was not built with author-year capability).
%%
%% This is derived from `splncsnat.bst',
%---------------------------------------------------------------------

ENTRY
  { address
    author
    booktitle    % for articles in books
    chapter      % for incollection, esp. internet documents
    day
    edition
    editor
    eid
    howpublished
    institution  % for technical reports
    location     % for patents
    journal
    key
    month
    note
    number
    organization
    pages
    part
    publisher
    school
    series
    title
    type
    url
    urldate
    volume
    word
    year
    doi
  }
  {}
  { label extra.label sort.label short.list }
INTEGERS { output.state before.all mid.sentence after.sentence after.block }
FUNCTION {init.state.consts}
{ #0 'before.all :=
  #1 'mid.sentence :=
  #2 'after.sentence :=
  #3 'after.block :=
}
%% Declaration of string variables
STRINGS { s t}
FUNCTION {output.nonnull}
{ 's :=
  output.state mid.sentence =
    { ", " * write$ }
    { output.state after.block =
        { add.period$ write$
          newline$
          "\newblock " write$
        }
        { output.state before.all =
            'write$
            {  " " * write$ }
          if$
        }
      if$
      mid.sentence 'output.state :=
    }
  if$
  s
}
FUNCTION {output}
{ duplicate$ empty$
    'pop$
    'output.nonnull
  if$
}

FUNCTION {output.check}
{ 't :=
  duplicate$ empty$
    { pop$ "empty " t * " in " * cite$ * warning$ }
    'output.nonnull
  if$
}

%FUNCTION {fin.entry}
%{ duplicate$ empty$
%    'pop$
%    'write$
%  if$
%  newline$
%}
%
FUNCTION {fin.entry}
{ add.period$
  write$
  newline$
}

FUNCTION {new.block}
{ output.state before.all =
    'skip$
    { after.block 'output.state := }
  if$
}

FUNCTION {new.sentence}
{ output.state after.block =
    'skip$
    { output.state before.all =
        'skip$
        { after.sentence 'output.state := }
      if$
    }
  if$
}

FUNCTION {add.blank}
{  " " * before.all 'output.state :=
}

FUNCTION {no.blank.or.punct}
{  "" * before.all 'output.state :=
}

FUNCTION {add.semicolon}
{
  ";" *
  no.blank.or.punct
}

FUNCTION {date.block}
{
  "." *
  no.blank.or.punct
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%            LOGICAL `NOT', `AND', AND `OR'                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Logical 'not':
% If the first element on the stack is A then this function
% does the following:
%     push { #0 }
%     push { #1 }
% So now the first 3 elements of the stack are
%     { #1 } { #0 } A
% The first 3 are popped and subjected to 'if':
% If A > 0 then { #0 } is executed, else { #1 } is executed:
%     if A > 0
%     then 0
%     else 1
% So consider integers as logicals, where 1 = true and 0 = false,
% then this does
%     (if A then false else true)
% which is a logical 'not'.

FUNCTION {not}
{   { #0 }
    { #1 }
  if$
}
FUNCTION {and}
{   'skip$
    { pop$ #0 }
  if$
}
FUNCTION {or}
{   { pop$ #1 }
    'skip$
  if$
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  GENERAL PURPOSE FUNCTIONS FOR FORMATTING                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% issues warning if field is empty
% call with
%    "field"  field  warning.if.empty
% Note that the first field must be between quotes
% because it is the fieldname for use in the warning message.
%

FUNCTION {warning.if.empty}
{ empty$
    { "No "  swap$ * " in " * cite$ * warning$ }
    { pop$ }
  if$
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %
    % encloses string in pre- and postfix string
    % call with
    %    prefix postfix  S  enclose.check
    % delivers empty string if S empty
    %
FUNCTION {enclose.check}
{ duplicate$ empty$
    { pop$ pop$ pop$
      ""
    }
    { swap$ * * }
  if$
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% emphasizes top of stack
% call with
%    string" emphasize.check
%

FUNCTION {emphasize.check}
{ "\emph{" swap$
  "}"     swap$
  enclose.check
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %
    % brackets top of stack
    % call with
    %     "string" bracket.check
    %
FUNCTION {bracket.check}
{ "[" swap$
  "]" swap$
  enclose.check
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %
    % parenthesizes top of stack
    % call with
    %     "string" parenthesize
    %
FUNCTION {parenthesize.check}
{ "(" swap$
  ")" swap$
  enclose.check
}

STRINGS {z}

FUNCTION {remove.dots}
{ 'z :=	% expects string on top of the stack, pops the string and assigns it to variable z
  "" % push empty string
  { z empty$ not } % returns 0 if variable z is empty
  { z #1 #1 substring$ % push the first character of variable z
    z #2 global.max$ substring$ 'z := % assigns the 2nd to last character of variable z to variable z
    duplicate$ "\" = % pushes 1 if the last character is "\", otherwise 0
    { * % concatenates the last 2 literals
      z #1 #1 substring$ % push the first character of variable z
      z #2 global.max$ substring$ 'z := % assigns the 2nd to last character of variable z to variable z
      * % concatenates the last 2 literals, i.e. every character, even a dot, following a "\" will be printed
    }
    { duplicate$ "." = % pushes 1 if the last character is ".", otherwise 0
      'pop$ %  pushes the pop$ function
      { * } % concatenates the last 2 literals
    if$ % pops the last character if it is a dot, otherwise concatenates it with the string on top of the stack
    }
    if$
  }
  while$
}

INTEGERS {l}
FUNCTION{string.length}
{
  #1 'l :=
  { duplicate$ duplicate$ #1 l substring$ = not }
    { l #1 + 'l := }
  while$
  pop$ l
}

STRINGS {replace find text}
INTEGERS {find_length}
FUNCTION {find.replace}
{
  'replace :=
  'find :=
  'text :=
  find string.length 'find_length :=
  ""
    { text empty$ not }
    { text #1 find_length substring$ find =
      {
        replace *
        text #1 find_length + global.max$ substring$ 'text :=
      }
      { text #1 #1 substring$ *
        text #2  global.max$ substring$ 'text :=
      }
    if$
    }
  while$
}

FUNCTION {new.block.checka}
{ empty$
    'skip$
    'new.block
  if$
}

FUNCTION {new.block.checkb}
{ empty$
  swap$ empty$
  and
    'skip$
    'new.block
  if$
}

FUNCTION {new.sentence.checka}
{ empty$
    'skip$
    'new.sentence
  if$
}

FUNCTION {new.sentence.checkb}
{ empty$
  swap$ empty$
  and
    'skip$
    'new.sentence
  if$
}

FUNCTION {field.or.null}
{ duplicate$ empty$
    { pop$ "" }
    'skip$
  if$
}

FUNCTION {emphasize}
{ skip$ }

FUNCTION {tie.or.space.prefix}
{ duplicate$ text.length$ #3 <
    { "~" }
    { " " }
  if$
  swap$
}

FUNCTION {capitalize}
{ "u" change.case$ "t" change.case$ }

FUNCTION {space.word}
{ " " swap$ * " " * }

 % Here are the language-specific definitions for explicit words.
 % Each function has a name bbl.xxx where xxx is the English word.
 % The language selected here is ENGLISH

FUNCTION {bbl.and}
{ "and"}

FUNCTION {bbl.etal}
{ "et~al." }

FUNCTION {bbl.editors}
{ "(ed)" }

FUNCTION {bbl.editor}
{ "(ed)" }

FUNCTION {bbl.edby}
{ "edited by" }

FUNCTION {bbl.edition}
{ "ed" }

FUNCTION {bbl.volume}
{ "vol" }

FUNCTION {bbl.of}
{ "of" }

FUNCTION {bbl.number}
{ "no" }

FUNCTION {bbl.nr}
{ "no" }

FUNCTION {bbl.in}
{ "in" }

FUNCTION {bbl.pages}
{ "p" }

FUNCTION {bbl.page}
{ "p" }

FUNCTION {bbl.chapter}
{ "chap" }

FUNCTION {bbl.techrep}
{ "Tech Rep" }

FUNCTION {bbl.mthesis}
{ "Master's thesis" }

FUNCTION {bbl.phdthesis}
{ "PhD thesis" }

FUNCTION {bbl.patent}
{ "patent" }

FUNCTION {bbl.acc.number}
{ "accession no." }

FUNCTION {bbl.acc.number.none}
{ "accession number requested" }

FUNCTION {bbl.abstract}
{ "abstr" }

FUNCTION {bbl.inpress}
{ "in press" }

FUNCTION {bbl.first}
{ "1st" }

FUNCTION {bbl.second}
{ "2nd" }

FUNCTION {bbl.third}
{ "3rd" }

FUNCTION {bbl.fourth}
{ "4th" }

FUNCTION {bbl.fifth}
{ "5th" }

FUNCTION {bbl.st}
{ "st" }

FUNCTION {bbl.nd}
{ "nd" }

FUNCTION {bbl.rd}
{ "rd" }

FUNCTION {bbl.th}
{ "th" }

MACRO {jan} {"Jan."}

MACRO {feb} {"Feb."}

MACRO {mar} {"Mar."}

MACRO {apr} {"Apr."}

MACRO {may} {"May"}

MACRO {jun} {"Jun."}

MACRO {jul} {"Jul."}

MACRO {aug} {"Aug."}

MACRO {sep} {"Sep."}

MACRO {oct} {"Oct."}

MACRO {nov} {"Nov."}

MACRO {dec} {"Dec."}

FUNCTION {eng.ord}
{ duplicate$ "1" swap$ *
  #-2 #1 substring$ "1" =
     { bbl.th * }
     { duplicate$ #-1 #1 substring$
       duplicate$ "1" =
         { pop$ bbl.st * }
         { duplicate$ "2" =
             { pop$ bbl.nd * }
             { "3" =
                 { bbl.rd * }
                 { bbl.th * }
               if$
             }
           if$
          }
       if$
     }
   if$
}

FUNCTION {bibinfo.check}
{ swap$
  duplicate$ missing$
    {
      pop$ pop$
      ""
    }
    { duplicate$ empty$
        {
          swap$ pop$
        }
        { swap$
          pop$
        }
      if$
    }
  if$
}

FUNCTION {bibinfo.warn}
{ swap$
  duplicate$ missing$
    {
      swap$ "missing " swap$ * " in " * cite$ * warning$ pop$
      ""
    }
    { duplicate$ empty$
        {
          swap$ "empty " swap$ * " in " * cite$ * warning$
        }
        { swap$
          pop$
        }
      if$
    }
  if$
}
INTEGERS { nameptr namesleft numnames }


STRINGS  { bibinfo}

FUNCTION {format.names}
{ 'bibinfo :=
  duplicate$ empty$ 'skip$ {
  "." ". " find.replace 's :=
  "" 't :=
  #1 'nameptr :=
  s num.names$ 'numnames :=
  numnames 'namesleft :=
    { namesleft #0 > }
    { s nameptr
      "{vv~}{ll}{ f{}}{ jj}"
      format.name$
      remove.dots
      bibinfo bibinfo.check
      't :=
      nameptr #1 >
         {
%% 31 Aug 2017: Don't abbreviate, list all authors
%           nameptr #6
%           #1 + =
%           numnames #6
%           > and
%             { "others" 't :=
%               #1 'namesleft := }
%             'skip$
%           if$
          namesleft #1 >
            { ", " * t * }
            {
              "," *
              s nameptr "{ll}" format.name$ duplicate$ "others" =
                { 't := }
                { pop$ }
              if$
              t "others" =
                {
                  " " * bbl.etal *
                }
                { " " * t * }
              if$
            }
          if$
        }
        't
      if$
      nameptr #1 + 'nameptr :=
      namesleft #1 - 'namesleft :=
    }
  while$
  } if$
}

FUNCTION {format.names.org}
{ 'bibinfo :=
  duplicate$ empty$ 'skip$ {
  's :=
  "" 't :=
  #1 'nameptr :=
  s num.names$ 'numnames :=
  numnames 'namesleft :=
    { namesleft #0 > }
    { s nameptr
      "{ff~}{vv~}{ll}"
      format.name$
      bibinfo bibinfo.check
      't :=
      nameptr #1 >
        {
          namesleft #1 >
            { "; " * t * }
            {
              ";" *
              s nameptr "{ll}" format.name$ duplicate$ "others" =
                { 't := }
                { pop$ }
              if$
              t "others" =
                {
                  " " * bbl.etal *
                }
                { " " * t * }
              if$
            }
          if$
        }
        't
      if$
      nameptr #1 + 'nameptr :=
      namesleft #1 - 'namesleft :=
    }
  while$
  } if$
}

FUNCTION {format.names.ed}
{
  format.names
}
FUNCTION {format.key}
{ empty$
    { key field.or.null }
    { "" }
  if$
}

FUNCTION {format.authors}
{
  author "author" format.names
  %% "." *
  "\textbf{" swap$ * "}" *
  %%"." " " "author" find.replace format.names
}

FUNCTION {format.organizations}
{ organization "organization" format.names.org
}

FUNCTION {get.bbl.editor}
{ editor num.names$ #1 > 'bbl.editors 'bbl.editor if$ }

FUNCTION {format.editors}
{ editor "editor" format.names duplicate$ empty$ 'skip$
    {
      "," *
      " " *
      get.bbl.editor
      *
    }
  if$
}

FUNCTION {format.doi.url}
{
  doi empty$
    {
      url empty$
        { "" }
        {
          "\urlprefix\url{" url * "}" *
          new.block
          urldate empty$
            'skip$
            {
              ". Retrieved " * urldate *
              new.block
            }
          if$
        }
      if$
    }
    { "\doiprefix\doi{" doi * "}" * }
  if$
}

FUNCTION {format.note}
{
  note empty$
    { "" }
    { note #1 #1 substring$
      duplicate$ "{" =
        'skip$
        { output.state mid.sentence =
          { "l" }
          { "u" }
        if$
        change.case$
        }
      if$
      note #2 global.max$ substring$ * "note" bibinfo.check
    }
  if$
}

FUNCTION {format.title}
{ title "title" bibinfo.check
}


FUNCTION {author.editor.key.full}
{ author empty$
    { editor empty$
        { key empty$
            { cite$ #1 #3 substring$ }
            'key
          if$
        }
        { editor }
      if$
    }
    { author }
  if$
}

FUNCTION {author.key.full}
{ author empty$
    { key empty$
         { cite$ #1 #3 substring$ }
          'key
      if$
    }
    { author }
  if$
}

FUNCTION {editor.key.full}
{ editor empty$
    { key empty$
         { cite$ #1 #3 substring$ }
          'key
      if$
    }
    { editor }
  if$
}

FUNCTION {make.full.names}
{ type$ "book" =
  type$ "inbook" =
  or
    'author.editor.key.full
    { type$ "proceedings" =
        'editor.key.full
        'author.key.full
      if$
    }
  if$
}

FUNCTION {output.bibitem}
{ newline$
  "\bibitem[{" write$
  label write$
  ")" make.full.names duplicate$ short.list =
     { pop$ }
     { * }
   if$
  "}]{" * write$
  cite$ write$
  "}" write$
  newline$
  ""
  before.all 'output.state :=
}

FUNCTION {n.dashify}
{
  't :=
  ""
    { t empty$ not }
    { t #1 #1 substring$ "-" =
        { t #1 #2 substring$ "--" = not
            { "--" *
              t #2 global.max$ substring$ 't :=
            }
            {   { t #1 #1 substring$ "-" = }
                { "-" *
                  t #2 global.max$ substring$ 't :=
                }
              while$
            }
          if$
        }
        { t #1 #1 substring$ *
          t #2 global.max$ substring$ 't :=
        }
      if$
    }
  while$
}

%% Updated 2019, Dec 17
FUNCTION {word.in}
{ bbl.in capitalize emphasize.check
%  ":" *
  " " * }

FUNCTION {format.journal.date}
{
  month "month" bibinfo.check
  duplicate$ empty$
  year  "year"  bibinfo.check duplicate$ empty$
    {
      swap$ 'skip$
      { "there's a month but no year in " cite$ * warning$ }
      if$
      *
    }
    { swap$ 'skip$
        { %%%%% Dec 2019: swap to *month year*.
          %" " * swap$
          swap$ " " * swap$
        }
      if$
      *
      remove.dots
    }
  if$
  duplicate$ empty$
    'skip$
    {
      before.all 'output.state :=
    after.sentence 'output.state :=
    }
  if$
}

FUNCTION {format.date}
{
  month "month" bibinfo.check
  duplicate$ empty$
  year  "year"  bibinfo.check duplicate$ empty$
    { swap$ 'skip$
        { "there's a month but no year in " cite$ * warning$ }
      if$
      *
    }
    { swap$ 'skip$
        { %%%%% Dec 2019: swap to *month year*.
          %swap$
          %" " * swap$
          swap$ " " * swap$
        }
      if$
      *
    }
  if$
}

FUNCTION {format.btitle}
{ title "title" bibinfo.check
  duplicate$ empty$ 'skip$
    {
    }
  if$
}

FUNCTION {either.or.check}
{ empty$
    'pop$
    { "can't use both " swap$ * " fields in " * cite$ * warning$ }
  if$
}

FUNCTION {format.bvolume}
{ volume empty$
    { "" }
    { bbl.volume volume tie.or.space.prefix
      "volume" bibinfo.check * *
      series "series" bibinfo.check
      duplicate$ empty$ 'pop$
        { swap$ bbl.of space.word * swap$
          emphasize * }
      if$
      "volume and number" number either.or.check
    }
  if$
}

FUNCTION {format.number.series}
{ volume empty$
    { number empty$
        { series field.or.null }
        { output.state mid.sentence =
            { bbl.number }
            { bbl.number capitalize }
          if$
          number tie.or.space.prefix "number" bibinfo.check * *
          series empty$
            { "there's a number but no series in " cite$ * warning$ }
            { bbl.in space.word *
              series "series" bibinfo.check *
            }
          if$
        }
      if$
    }
    { "" }
  if$
}

FUNCTION {format.edition}
{ edition duplicate$ empty$ 'skip$
    {
%      convert.edition
      output.state mid.sentence =
        { "l" }
        { "t" }
      if$ change.case$
      "edition" bibinfo.check
      " " * bbl.edition *
    }
  if$
}
INTEGERS { multiresult }
FUNCTION {multi.page.check}
{ 't :=
  #0 'multiresult :=
    { multiresult not
      t empty$ not
      and
    }
    { t #1 #1 substring$
      duplicate$ "-" =
      swap$ duplicate$ "," =
      swap$ "+" =
      or or
        { #1 'multiresult := }
        { t #2 global.max$ substring$ 't := }
      if$
    }
  while$
  multiresult
}

FUNCTION {format.pages}
{ pages duplicate$ empty$ 'skip$
    { duplicate$ multi.page.check
        {
          bbl.pages swap$
          n.dashify
        }
        {
          bbl.page swap$
        }
      if$
      tie.or.space.prefix
      "pages" bibinfo.check
      * *
    }
  if$
}

FUNCTION {format.journal.pages}
{ pages duplicate$ empty$ 'pop$
    { swap$ duplicate$ empty$
        { pop$ pop$ format.pages }
        {
          ":" *
          swap$
          n.dashify
          "pages" bibinfo.check
          *
        }
      if$
    }
  if$
}

FUNCTION {format.vol.num}
{ volume field.or.null
  duplicate$ empty$ 'skip$
    {
      "volume" bibinfo.check
    }
  if$
  number "number" bibinfo.check duplicate$ empty$ 'skip$
    {
      swap$ duplicate$ empty$
        { "there's a number but no volume in " cite$ * warning$ }
        'skip$
      if$
      swap$
      "(" swap$ * ")" *
    }
  if$ *
}

FUNCTION {format.vol.num.pages}
{ volume field.or.null
  duplicate$ empty$ 'skip$
    {
      "volume" bibinfo.check
    }
  if$
  number "number" bibinfo.check duplicate$ empty$ 'skip$
    {
      swap$ duplicate$ empty$
        { "there's a number but no volume in " cite$ * warning$ }
        'skip$
      if$
      swap$
      " (" swap$ * ")" *
    }
  if$ *
  format.journal.pages
}

FUNCTION {format.chapter.pages}
{ chapter empty$
    'format.pages
    { type empty$
        { bbl.chapter }
		{ type "l" change.case$
		  "type" bibinfo.check
		}
	      if$
	      chapter tie.or.space.prefix
	      "chapter" bibinfo.check
	      * *
	      pages empty$
		'skip$
		{ ", " * format.pages * }
	      if$
	    }
	  if$
	}

	FUNCTION {format.booktitle}
	{
	  booktitle "booktitle" bibinfo.check
	}

	FUNCTION {format.in.ed.booktitle}
	{ format.booktitle duplicate$ empty$ 'skip$
	    {
	      editor "editor" format.names.ed duplicate$ empty$ 'pop$
		{
%		  "," *  %Removed Dec 17, 2019
		  " " *
		  get.bbl.editor
		  ", " *
		  * swap$
		  * }
	      if$
	      word.in swap$ *
	    }
	  if$
	}

	FUNCTION {format.in.ed.title}
	{ format.title duplicate$ empty$ 'skip$
	    {
	      editor "editor" format.names.ed duplicate$ empty$ 'pop$
		{
		  "," *
		  " " *
		  get.bbl.editor
		  ", " *
		  * swap$
		  * }
	      if$
	      word.in swap$ *
	    }
	  if$
	}

	FUNCTION {empty.misc.check}
	{ author empty$ title empty$ howpublished empty$
	  month empty$ year empty$ note empty$
	  and and and and and
	    { "all relevant fields are empty in " cite$ * warning$ }
	    'skip$
	  if$
	}
FUNCTION {format.thesis.type}
	{ type duplicate$ empty$
	    'pop$
	    { swap$ pop$
	      "t" change.case$ "type" bibinfo.check
    }
  if$
}
FUNCTION {format.tr.number}
{
    number "number" bibinfo.check
}

%% 2019 Dec 17: changed order of publisher and address
FUNCTION {format.org.or.pub}
{ 't :=
  ""
  address empty$ t empty$ and
    'skip$
    {
      t empty$
        { address "address" bibinfo.check *
        }
        { t *
          address empty$
            'skip$
            { ", " * address "address" bibinfo.check * }
          if$
        }
      if$
    }
  if$
}

FUNCTION {format.publisher.address}
{ publisher "publisher" bibinfo.warn
  format.org.or.pub
}

FUNCTION {format.organization.address}
{ organization "organization" bibinfo.check format.org.or.pub
}

FUNCTION {format.institution.address}
{ institution "institution" bibinfo.check format.org.or.pub
}
FUNCTION {format.article.crossref}
{
  word.in
  " \cite{" * crossref * "}" *
}
FUNCTION {format.book.crossref}
{ volume duplicate$ empty$
    { "empty volume in " cite$ * "'s crossref of " * crossref * warning$
      pop$ word.in
    }
    { bbl.volume
      capitalize
      swap$ tie.or.space.prefix "volume" bibinfo.check * * bbl.of space.word *
    }
  if$
  " \cite{" * crossref * "}" *
}
FUNCTION {format.incoll.inproc.crossref}
{
  word.in
  " \cite{" * crossref * "}" *
}
FUNCTION {misc}
{ output.bibitem
  format.authors "author" output.check
  date.block add.blank
  format.date "year" output.check
  new.block
  format.editors output % "author and editor" output.check  %% IS OPTIONAL
  format.title "title" output.check
  new.block
  format.publisher.address output
  no.blank.or.punct add.blank
  format.doi.url output
  new.block
  format.note output
  fin.entry
  empty.misc.check
}

FUNCTION{format.patent.number}
{
   location space.word bbl.patent * space.word number *
}

FUNCTION {patent}
{ output.bibitem
  format.authors "author" output.check
  date.block add.blank
  format.date "year" output.check
  new.block
  format.title "title" output.check
  new.block
  format.patent.number "location or number" output.check
  new.block
  format.note output
  fin.entry
}

FUNCTION {format.accession.number}
{ number empty$
    { bbl.acc.number.none "(" swap$ * ")" * }
    { bbl.acc.number "(" swap$ * space.word number * ")" * }
  if$
}

FUNCTION {dataset}
{ output.bibitem
  format.authors "author" output.check
  date.block add.blank
  format.date "year" output.check
  new.block
  format.title "title" output.check
  new.block
  format.publisher.address output
  no.blank.or.punct add.blank
  format.doi.url output
  no.blank.or.punct add.blank
  format.accession.number "number" output.check
  new.block
  format.note output
  fin.entry
}

FUNCTION {format.journal}
{
  "\JournalTitle{" journal * "}{}" *
}

FUNCTION {article}
{ output.bibitem
  format.authors "author" output.check
  date.block add.blank
  year empty$  %% Jan 2020: this is now optional
    'skip$
    {
     format.journal.date output %"year" output.check
     date.block add.blank
    }
  if$
  organization empty$
    'skip$
    { author empty$
        {
          format.organizations "organization" output.check
        }
        {
          "; " *
           no.blank.or.punct
          format.organizations "organization" output.check
        }
      if$
    }
  if$
  new.block
  format.title output % "title" output.check %% IS OPTIONAL
  type missing$
    { skip$ }
    { "type" output.check }
  if$
  new.block
  %%%%%% Mar 17, 2017 (LianTze) Abbreviates journal names
  format.journal "journal" output.check
  %%%%%% Jan 02, 2019 Now that year is optional: add "in press" if
  %%%%%% year field is indeed missing.
  year empty$
    {
      ", " * bbl.inpress *
      date.block add.blank
    }
    { skip$ }
  if$
  no.blank.or.punct
  add.blank
  format.vol.num.pages output
  new.block
  format.doi.url output
  new.block
  format.note output
  fin.entry
}

FUNCTION {format.conf.abstr.number}
{
  bbl.abstract space.word number *
}

FUNCTION {format.conf.booktitle}
{
  bbl.abstract "\MakeUppercase " swap$ *
  " \JournalTitle{" * booktitle * "}" *
}

FUNCTION {format.conf.abstr.with.title}
{
  format.title output
  format.conf.abstr.number "number" output.check
  format.pages output
  new.block
  format.conf.booktitle "booktitle" output.check
}

FUNCTION {format.conf.abstr.without.title}
{
  format.conf.booktitle "booktitle" output.check
  format.conf.abstr.number "number" output.check
  format.pages output
}

FUNCTION {confabstract}
{ output.bibitem
  format.authors "author" output.check
  date.block add.blank
  format.date "year" output.check
  date.block add.blank
  title empty$
    { format.conf.abstr.without.title }
    { format.conf.abstr.with.title }
  if$
  new.block
  publisher empty$
    { format.organization.address output }
    { organization "organization" bibinfo.check output
      format.publisher.address output
    }
  if$
  new.block
  format.doi.url output
  new.block
  format.note output
  fin.entry
}

FUNCTION {book}
{ output.bibitem
  author empty$
    { editor empty$
        { format.organizations "organization" output.check }
        { format.editors "author and editor" output.check }
      if$
    }
    { format.authors output.nonnull
      "author and editor" editor either.or.check
    }
  if$
  new.block
  format.date "year" output.check
  date.block add.blank
  format.btitle "title" output.check
  format.bvolume output
  new.block
  format.edition output
  new.sentence
  author empty$ not
  editor empty$ not
  and
    { format.editors "author and editor" output.check }
      'skip$
  if$
  format.number.series output
  format.publisher.address output
  %% format.date "year" output.check
  new.block
  format.doi.url output
  new.block
  format.note output
  fin.entry
}
FUNCTION {booklet}
{ misc }

FUNCTION {dictionary}
{ output.bibitem
  format.booktitle "booktitle" output.check
  format.bvolume output
  new.block
  format.edition output
  new.sentence
  format.publisher.address output
  format.date "year" output.check
  format.btitle "title" output.check
  add.semicolon
  add.blank
  format.pages "pages" output.check
  new.block
  format.doi.url output
  new.block
  format.note output
  fin.entry
}

FUNCTION {inbook}
{ output.bibitem
  format.authors "author" output.check
  date.block add.blank
  format.date "year" output.check
  date.block
  add.blank
  chapter "chapter" output.check
  new.block
  format.in.ed.title "title" output.check
  format.bvolume output
  format.edition output
  new.sentence
  format.number.series output
  format.publisher.address output
%  format.date "year" output.check
%  date.block
%  add.blank
  format.pages "pages" output.check
  new.block
  format.doi.url output
  new.block
  format.note output
  fin.entry
}

FUNCTION {incollection}
{ output.bibitem
  format.authors "author" output.check
  date.block add.blank
  year empty$
    'skip$
    {
      format.date output %"year" output.check  %% now optional
      date.block
      add.blank
    }
  if$
  format.title output % "title" output.check   %% IS OPTIONAL
  format.pages output % "pages" output.check   %% IS OPTIONAL
  new.block
  format.in.ed.booktitle "booktitle" output.check
  format.edition output
  format.bvolume output
  %%%%%% Jan 02, 2019 Now that year is optional: add "in press" if
  %%%%%% year field is indeed missing.
  year empty$
    {
      ", " * bbl.inpress *
      date.block add.blank
    }
    { skip$ }
  if$
%  new.sentence %% Modified 2019, Dec 17
  new.block
  format.number.series output
  format.publisher.address output
  new.block
  format.doi.url output
  new.block
  format.note output
  fin.entry
}
FUNCTION {inproceedings}
{ output.bibitem
  format.authors "author" output.check
  date.block add.blank
  format.date "year" output.check
  date.block add.blank
  format.title "title" output.check
  new.block
  format.in.ed.booktitle "booktitle" output.check
  format.bvolume output
  new.sentence
  format.number.series output
  publisher empty$
    { format.organization.address output }
    { organization "organization" bibinfo.check output
      format.publisher.address output
    }
  if$
%  format.date "year" output.check
%  date.block
%  add.blank
  format.pages "pages" output.check
  new.block
  format.doi.url output
  new.block
  format.note output
  fin.entry
}
FUNCTION {conference} { inproceedings }
FUNCTION {manual}
{ output.bibitem
  format.authors output
  author format.key output
%  add.colon
  new.block
  format.date "year" output.check
  date.block add.blank new.block
  format.btitle "title" output.check
  organization address new.block.checkb
  organization "organization" bibinfo.check output
  address "address" bibinfo.check output
  format.edition output
  % format.date "year" output.check
  new.block
  format.doi.url output
  new.block
  format.note output
  fin.entry
}

FUNCTION {phdthesis}
{ output.bibitem
  format.authors "author" output.check
  date.block add.blank
  format.date "year" output.check
  date.block add.blank
  format.btitle output %"title" output.check  %% IS OPTIONAL
  new.block
  "PhD thesis" format.thesis.type output.nonnull
  new.block
  school "school" bibinfo.warn output
  address "address" bibinfo.check output
%  format.date "year" output.check
  new.block
  format.doi.url output
  new.block
  format.note output
  fin.entry
}

FUNCTION {proceedings}
{ output.bibitem
  format.editors output
  editor format.key output
%  add.colon
  new.block
  format.date "year" output.check
  date.block add.blank
  format.btitle "title" output.check
  format.bvolume output
  new.sentence
  format.number.series output
  publisher empty$
    { format.organization.address output }
    { organization "organization" bibinfo.check output
      format.publisher.address output
    }
  if$
%  format.date "year" output.check
  % new.block       ++++ REMOVED (to get comma before note)
  format.doi.url output
  new.block
  format.note output
  fin.entry
}

FUNCTION {techreport}
{ output.bibitem
  format.authors "author" output.check
  date.block add.blank
  format.date "year" output.check
  date.block add.blank
  format.title
  "title" output.check
  new.block
  format.institution.address output
%  format.date "year" output.check
%  format.tr.number output.nonnull
  new.block
  format.note output
  fin.entry
}

FUNCTION {unpublished}
{ output.bibitem
  format.authors "author" output.check
  author format.key output
%  add.colon
  new.block
  format.date "year" output.check
  date.block add.blank
  format.title "title" output.check
%  format.date "year" output.check
  % new.block       ++++ REMOVED (to get comma before note)
  format.note "note" output.check
  fin.entry
}

FUNCTION {default.type} { misc }
READ
FUNCTION {sortify}
{ purify$
  "l" change.case$
}
INTEGERS { len }
FUNCTION {chop.word}
{ 's :=
  'len :=
  s #1 len substring$ =
    { s len #1 + global.max$ substring$ }
    's
  if$
}
FUNCTION {format.lab.names}
{ 's :=
  "" 't :=
  s #1 "{vv~}{ll}" format.name$
  s num.names$ duplicate$
  #2 >
    { pop$
      " " * bbl.etal *
    }
    { #2 <
        'skip$
        { s #2 "{ff }{vv }{ll}{ jj}" format.name$ "others" =
            {
              " " * bbl.etal *
            }
            { bbl.and space.word * s #2 "{vv~}{ll}" format.name$
              * }
          if$
        }
      if$
    }
  if$
}

FUNCTION {author.key.label}
{ author empty$
    { key empty$
        { cite$ #1 #3 substring$ }
        'key
      if$
    }
    { author format.lab.names }
  if$
}

FUNCTION {author.editor.key.label}
{ author empty$
    { editor empty$
        { key empty$
            { cite$ #1 #3 substring$ }
            'key
          if$
        }
        { editor format.lab.names }
      if$
    }
    { author format.lab.names }
  if$
}

FUNCTION {editor.key.label}
{ editor empty$
    { key empty$
        { cite$ #1 #3 substring$ }
        'key
      if$
    }
    { editor format.lab.names }
  if$
}

FUNCTION {calc.short.authors}
{ type$ "book" =
  type$ "inbook" =
  or
    'author.editor.key.label
    { type$ "proceedings" =
        'editor.key.label
        'author.key.label
      if$
    }
  if$
  'short.list :=
}

FUNCTION {calc.label}
{ calc.short.authors
  short.list
  "("
  *
  year duplicate$ empty$
     { pop$ "????" }
     'skip$
  if$
  *
  'label :=
}

FUNCTION {sort.format.names}
{ 's :=
  #1 'nameptr :=
  ""
  s num.names$ 'numnames :=
  numnames 'namesleft :=
    { namesleft #0 > }
    { s nameptr
      "{ll{ }}{  ff{ }}{  jj{ }}"
      format.name$ 't :=
      nameptr #1 >
        {
          "   "  *
          namesleft #1 = t "others" = and
            { "zzzzz" * }
            { t sortify * }
          if$
        }
        { t sortify * }
      if$
      nameptr #1 + 'nameptr :=
      namesleft #1 - 'namesleft :=
    }
  while$
}

FUNCTION {sort.format.title}
{ 't :=
  "A " #2
    "An " #3
      "The " #4 t chop.word
    chop.word
  chop.word
  sortify
  #1 global.max$ substring$
}
FUNCTION {author.sort}
{ author empty$
    { key empty$
        { "to sort, need author or key in " cite$ * warning$
          ""
        }
        { key sortify }
      if$
    }
    { author sort.format.names }
  if$
}
FUNCTION {author.editor.sort}
{ author empty$
    { editor empty$
        { key empty$
            { "to sort, need author, editor, or key in " cite$ * warning$
              ""
            }
            { key sortify }
          if$
        }
        { editor sort.format.names }
      if$
    }
    { author sort.format.names }
  if$
}
FUNCTION {editor.sort}
{ editor empty$
    { key empty$
        { "to sort, need editor or key in " cite$ * warning$
          ""
        }
        { key sortify }
      if$
    }
    { editor sort.format.names }
  if$
}
FUNCTION {presort}
{ calc.label
  label sortify
  "    "
  *
  type$ "book" =
  type$ "inbook" =
  or
    'author.editor.sort
    { type$ "proceedings" =
        'editor.sort
        'author.sort
      if$
    }
  if$
  #1 entry.max$ substring$
  'sort.label :=
  sort.label
  *
  "    "
  *
  title field.or.null
  sort.format.title
  *
  #1 entry.max$ substring$
  'sort.key$ :=
}

ITERATE {presort}
%SORT
STRINGS { last.label next.extra }
INTEGERS { last.extra.num number.label }
FUNCTION {initialize.extra.label.stuff}
{ #0 int.to.chr$ 'last.label :=
  "" 'next.extra :=
  #0 'last.extra.num :=
  #0 'number.label :=
}
FUNCTION {forward.pass}
{ last.label label =
    { last.extra.num #1 + 'last.extra.num :=
      last.extra.num int.to.chr$ 'extra.label :=
    }
    { "a" chr.to.int$ 'last.extra.num :=
      "" 'extra.label :=
      label 'last.label :=
    }
  if$
  number.label #1 + 'number.label :=
}
FUNCTION {reverse.pass}
{ next.extra "b" =
    { "a" 'extra.label := }
    'skip$
  if$
  extra.label 'next.extra :=
  extra.label
  duplicate$ empty$
    'skip$
    { "{\natexlab{" swap$ * "}}" * }
  if$
  'extra.label :=
  label extra.label * 'label :=
}
%EXECUTE {initialize.extra.label.stuff}
%ITERATE {forward.pass}
%REVERSE {reverse.pass}
FUNCTION {bib.sort.order}
{ sort.label
  "    "
  *
  year field.or.null sortify
  *
  "    "
  *
  title field.or.null
  sort.format.title
  *
  #1 entry.max$ substring$
  'sort.key$ :=
}
% ITERATE {bib.sort.order}
% SORT
FUNCTION {begin.bib}
{ preamble$ empty$
    'skip$
    { preamble$ write$ newline$ }
  if$
  "\begin{thebibliography}{" number.label int.to.str$ * "}" *
  write$ newline$
  "\providecommand{\natexlab}[1]{#1}"
  write$ newline$
  "\providecommand{\url}[1]{\texttt{#1}}"
  write$ newline$
  "\providecommand{\urlprefix}{}"
  write$ newline$
  "\providecommand{\doiprefix}{doi:\allowbreak}"
  write$ newline$
  "\providecommand{\doi}[1]{\href{https://doi.org/#1}{\detokenize{#1}}}"
  write$ newline$
}
EXECUTE {begin.bib}
EXECUTE {init.state.consts}
ITERATE {call.type$}
FUNCTION {end.bib}
{ newline$
  "\end{thebibliography}" write$ newline$
}
EXECUTE {end.bib}
%% End of customized bst file
%%
%% End of file `splncsnat.bst'.
