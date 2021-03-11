# ZevenK - 7% Keyboard

... TODO ... (currently in gdocs)

# Keyboard Mappings Files

By default a single "compiled" file of all keyboard mappings is read at startup. It is named (asdfg.lst) In it, all keyboard actions are mapped to letter, numbers, symbols, and CTRL-, ALT-, and F- keys, as well as some specific commands.

Without a mapping's file, you'd only be able to write 'asdfg'+space. Every other letter, number and keys are "virtual" thus defined using "clever" key-combinations extending the keyboard.

## Format

The format has 3 vital componets separated by mostly tabs (\t). Anything after '#' is ignored as it's a comment. First on each line is the 'asdfg' specification of what the user types, and after a tab is a list of space separated words.

  asdfg   TAB     word ... # comment

Example:

  %e_     every_ # common word

Notice that the shorthand 'e' for 'every' is prefixed by a '%'. This is to not expand every 'e' whenver it's typed. '%' limits the expansion of the contraction to only occur at the beginning of a word. Similarly, the trailing '_' will ensure that the contraction is only expanded when the space has been tapped. This allows other words starting with 'e' to be typed. Finally, the resulting word 'every_' includes a space, denoted by the shorthand character _ (to avoid quoting).

There are few cases, special shorthand keys that type words not caring aboutthe characters typed before. Those are:

  A-_     and_
  S-_     :HARDSPACE # see commands
  D-_     the_
  F-_     for_
  G-_     :NUMLOCK # see commands

This allows you to hold down 'a' and tap the space-key to type 'the ', including trailing space. Same for 'the 'and 'for '.

### UI implementation notes

If there is only a singular word, then the substitution takes place immediately. And, otherwise, the user interface may beep and give the user a choice to disambiguate. The ZevenK software will pick the first word if space is tapped, or otherwise it will continue leaving the choices to be dealt with later by the user. This is convenient when "typing blindly", where speed is more important than momentarily precision.

## Contractions convention

Contractions are short sequence of letters typed that uniquely denote very common words. The contractions we use are highly inspired and mostly compatibnle with Braill, the blind-writing alphabet and system, that uses special contraction prefix charactere (1-4). In our case, we have no such single character, instead we use a single symbole '.,!?' directly followed by (mostly) one letter.

* single letter (f = from)
* double letter (
* .
* ,
* !
* ?

Each of these contraction symbols are easy to write, just doing a "dot-shift" (d-) and one of ths letter 'as fg' mapped to '., !?' respectively.

The '?' contractions are few and are encouraged to be extended in the user.lst private file. But, indeed, any symbol may be used to start a contraction, however, choose with care as typing unusual ones may be a struggle.

The ':' character is "reserved" for usage of ZevenK's internal commands, and shifted key notations. Most of which's interpreations  are hardcoded in the software. More in the next section.

## Commands

As previously said, the ':' prefix is used to distinguish key combos and (internal) commands hardcoded in the software.

The commands are (grouped by function):

  # combi keys generated by keyboard
  asdfg        # leters, not a command
  :S-A         # 's'-shift 'a'  
  :S-AG        #      "    +  'g'
  :S-GA        # diffent sequence
  :_-G         # space-shift 'g'
  :{asdf}      # 4 key chord pressed
  :{sf}        # 2 key chord
  :A>S         # roll from 'a' to 's'
  :_-A>S       # roll up to 'q'
  :_-S>A       # roll down to 'x'
  :_>_         # "wack back"
  
  # editing
  :BS          # backspace
  :DEL         # delete (TODO)
  :RETURN      # return key (TODO)

  :HARDSPACE   # a plain space
  :CLEAR       # clear text (delete)
  :DELSPC      # deletes previos white space
  :DELETE-WORD # deletes previous word
  :MATCH       # search dictionary

  # cursor movement (TODO!)
  :UP
  :DOWN
  :LEFT
  :RIGHT
  :PGUP
  :GPDN
  :HOME
  :END
  :BOL
  :EOL
  :BACK-WORD   # haha
  :FOR-WORD    # hahaha

  # modes
  :NUMLOCK     # (TODO)
  :CAPSLOCK

  # capitalization etc
  :NEXTCAP
  :JOIN        # join last two words
  :CAPITALIZE  # Capitalize last word
  :UPPERCASE   # UPPERCASE last words
  :LOWERCASE   # lowercase LAST 2
  :CAMELIFY    # CamelCase last 2
  :UNDERSCORE  # under_score last 2
  :DASHIFY     # dash-ify last 2

  :BEEP        # beep!

  # system functions (TODO
  :HELP
  :SEARCH
  :FILE	       # 
  :MENU
  :SYSTEM
  :RESET
  :SHUTDOWN

  :DEFAULT     # user didn't pick/or choose default

  # any command (by convention) that wiats for input ends with a '-'
  :WAITSPACE-  # igores input till space
  :PICK-       # pick one choice

  # markup (TODO)
  # (mostly just use MD/wiki-style)
  :BOOKMARK    # creates a doc uniq bookmark on form ' d7zg:HERE '
  :HERE        # previous letters name a bookmark
  :GOTO        # go to (local) bookmark
  :LOCATE      # locate document+go bookmark

# ZevenZ - 7 Systems

(ok, bad name but I once had a Swedish "cult"-legacy CP/M Z80 computer from the 1980s that was named "Seven S" (for systems))

The goal of ZevenZ is to be my personal, portable information system, very much as outlined in MOAD (The Mother of All Demos) by Dough Engelbart in 1968--the year I was born.

What are the Zeven Zystems then:
1. file system
2. wiki
3. editor
4. 5-key single-handedkeyboard
5. offline/online/sync
6. webserver
7. programming environment

It had the follwing features:
- (see file MOAD.txt)
- ...

# Wiki

All textfields can contain wiki text and hyper link in ZevenZ. This allows the description of a calendar event be inlining text from a wiki.

The Wiki is actually just an text-formatting markup together with an built-in edit function with versioning.

# Panda Macro Language

(TODO)

To facilitate scripting and automatization we need a tiny language, text oriented. JML is such a small language, written in C to run in embedded systems. Panda is another language to which more works and looks like Unix pipes. Panda Micro Language is a syntax that allows both.

[=tag $h @txt | <$h>@txt</$h>]
[=tripple  $s | $s$s$s]
[=number-list $from $to |
  [tag ul [ $from to $to | tag li ]]]
[=word-list @words |
  [tag ul [ for @words | tag li ]]]