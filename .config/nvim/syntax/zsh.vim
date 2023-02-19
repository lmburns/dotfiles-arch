" Vim syntax file
" Language:             Zsh shell script
" Maintainer:           Christian Brabandt <cb@256bit.org>
" Previous Maintainer:  Nikolai Weibull <now@bitwi.se>
" Latest Revision:      2022-07-26
" License:              Vim (see :h license)
" Repository:           https://github.com/chrisbra/vim-zsh

if exists("b:current_syntax")
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

function! s:ContainedGroup()
  " needs 7.4.2008 for execute() function
  let result='TOP'
    " vim-pandoc syntax defines the @langname cluster for embedded syntax languages
    " However, if no syntax is defined yet, `syn list @zsh` will return
    " "No syntax items defined", so make sure the result is actually a valid syn cluster
    for cluster in ['markdownHighlight_zsh', 'zsh']
      try
      " markdown syntax defines embedded clusters as @markdownhighlight_<lang>,
      " pandoc just uses @<lang>, so check both for both clusters
        let a=split(execute('syn list @'. cluster), "\n")
        if len(a) == 2 && a[0] =~# '^---' && a[1] =~? cluster
          return  '@'. cluster
        endif
      catch /E392/
        " ignore
      endtry
    endfor
    return result
endfunction

let s:contained=s:ContainedGroup()

syn iskeyword @,48-57,_,192-255,#,-
if get(g:, 'zsh_fold_enable', 0)
    setlocal foldmethod=syntax
endif

syn match   zshQuoted           '\\.'
syn match   zshPOSIXQuoted      '\\[xX][0-9a-fA-F]\{1,2}'
syn match   zshPOSIXQuoted      '\\[0-7]\{1,3}'
syn match   zshPOSIXQuoted      '\\u[0-9a-fA-F]\{1,4}'
syn match   zshPOSIXQuoted      '\\U[1-9a-fA-F]\{1,8}'

syn region  zshString           matchgroup=zshStringDelimiter start=+"+ end=+"+
                                \ contains=@Spell,zshQuoted,@zshDerefs,@zshSubstQuoted fold
syn region  zshString           matchgroup=zshStringDelimiter start=+'+ end=+'+ fold
                                \ contains=@Spell
syn region  zshPOSIXString      matchgroup=zshStringDelimiter start=+\$'+
                                \ skip=+\\[\\']+ end=+'+ contains=zshPOSIXQuoted,zshQuoted
syn match   zshJobSpec          '%\(\d\+\|?\=\w\+\|[%+-]\)'

syn match   zshNumber           '[+-]\=\<\d\+\>'
syn match   zshNumber           '[+-]\=\<[0-9_]\+\>'
syn match   zshNumber           '[+-]\=\<0x\x\+\>'
syn match   zshNumber           '[+-]\=\<0\o\+\>'
syn match   zshNumber           '[+-]\=\d\+#[-+]\=\w\+\>'
syn match   zshNumber           '[+-]\=\d\+\.\d\+\>'

syn keyword zshPrecommand       noglob nocorrect exec command builtin - time

syn keyword zshDelimiter        do done end

syn keyword zshConditional      if then elif else fi esac select

syn keyword zshCase             case nextgroup=zshCaseWord skipwhite
syn match zshCaseWord           /\S\+/ nextgroup=zshCaseIn skipwhite contained transparent
syn keyword zshCaseIn           in nextgroup=zshCasePattern skipwhite skipnl contained
syn match zshCasePattern        /\S[^)]*)/ contained

syn keyword zshRepeat           while until repeat
syn keyword zshRepeat           for foreach nextgroup=zshVariable skipwhite
syn keyword zshException        always
syn keyword zshKeyword          function nextgroup=zshKSHFunction skipwhite

" syn match   zshKSHFunction      contained '\w\S\+'
" syn match   zshFunction         '^\s*\k\+\ze\s*()'

" My modification to allow for functions that start with or contain [:→.@+-]
syn match   zshKSHFunction      contained '\(\w\|[:→.@+-]\)\S\+'
syn match   zshFunction         '^\s*\(\k\|[:→.@+-]\)\+\ze\s*()'

syn match   zshOperator         '||\|&&\|;\|&!\='

" syn match   zshRedir            '\d\=\(<\|<>\|<<<\|<&\s*[0-9p-]\=\)'
" syn match   zshRedir            '\d\=\(>\|>>\|>&\s*[0-9p-]\=\|&>\|>>&\|&>>\)[|!]\='
" syn match   zshRedir            '|&\='

                                " <<<, <, <>, and variants.
syn match   zshRedir            '\d\=\(<<<\|<&\s*[0-9p-]\=\|<>\?\)'
                                " >, >>, and variants.
syn match   zshRedir            '\d\=\(>&\s*[0-9p-]\=\|&>>\?\|>>\?&\?\)[|!]\='
                                " | and |&, but only if it's not preceeded or followed by a | to avoid matching ||.
syn match   zshRedir            '|\@1<!|&\=|\@!'

syn region  zshHereDoc          matchgroup=zshRedir
                                \ start='<\@<!<<\s*\z([^<]\S*\)'
                                \ end='^\z1$'
                                \ contains=@Spell,@zshSubst,@zshDerefs,zshQuoted,zshPOSIXString
syn region  zshHereDoc          matchgroup=zshRedir
                                \ start='<\@<!<<\s*\\\z(\S\+\)'
                                \ end='^\z1$'
                                \ contains=@Spell
syn region  zshHereDoc          matchgroup=zshRedir
                                \ start='<\@<!<<-\s*\\\=\z(\S\+\)'
                                \ end='^\t*\z1$'
                                \ contains=@Spell
syn region  zshHereDoc          matchgroup=zshRedir
                                \ start=+<\@<!<<\s*\(["']\)\z(\S\+\)\1+
                                \ end='^\z1$'
                                \ contains=@Spell
syn region  zshHereDoc          matchgroup=zshRedir
                                \ start=+<\@<!<<-\s*\(["']\)\z(\S\+\)\1+
                                \ end='^\t*\z1$'
                                \ contains=@Spell

syn match   zshVariable         '\<\h\w*' contained

syn match   zshVariableDef      '\<\h\w*\ze+\=='
" XXX: how safe is this?
syn region  zshVariableDef      oneline
                                \ start='\$\@<!\<\h\w*\[' end='\]\ze+\?=\?'
                                \ contains=@zshSubst

syn cluster zshDerefs           contains=zshShortDeref,zshLongDeref,zshDeref,zshDollarVar

syn match zshShortDeref       '\$[!#$*@?_-]\w\@!'
syn match zshShortDeref       '\$[=^~]*[#+]*\d\+\>'

syn match zshLongDeref        '\$\%(ARGC\|argv\|status\|pipestatus\|CPUTYPE\|EGID\|EUID\|ERRNO\|GID\|HOST\|LINENO\|LOGNAME\)'
syn match zshLongDeref        '\$\%(MACHTYPE\|OLDPWD OPTARG\|OPTIND\|OSTYPE\|PPID\|PWD\|RANDOM\|SECONDS\|SHLVL\|signals\)'
syn match zshLongDeref        '\$\%(TRY_BLOCK_ERROR\|TTY\|TTYIDLE\|UID\|USERNAME\|VENDOR\|ZSH_NAME\|ZSH_VERSION\|REPLY\|reply\|TERM\)'

syn match zshDollarVar        '\$\h\w*'
syn match zshDeref            '\$[=^~]*[#+]*\h\w*\>'

syn match   zshCommands         '\%(^\|\s\)[.:]\ze\s'
syn keyword zshCommands         alias        autoload     bg          bindkey       break      bye cap
                              \ cd           chdir        clone       comparguments compcall   compctl
                              \ compdescribe compfiles    compgroups  compquote     comptags   comptry
                              \ compvalues   continue     dirs        disable       disown     echo
                              \ echotc       echoti       emulate     enable        eval       exec
                              \ exit         export       false       fc            fg         functions
                              \ getcap       getln        getopts     hash          history    jobs
                              \ kill         let          limit       log           logout     popd
                              \ print        printf       prompt      pushd         pushln     pwd
                              \ r            read         rehash      return        sched      set
                              \ setcap       shift        source      stat          suspend    test
                              \ times        trap         true        ttyctl        type       ulimit
                              \ umask        unalias      unfunction  unhash        unlimit    unset
                              \ vared        wait         whence      where         which      zcompile
                              \ zformat      zftp         zle         zmodload      zparseopts zprof
                              \ zpty         zrecompile   zregexparse zsocket       zstyle     ztcp
                              \ coproc       zgetattr     zsetattr    zlistattr     zdelattr   zcurses
                              \ strftime     ztie         zuntie      zgdbmpath     zf_chgrp   zf_chmod
                              \ zf_chown     zf_ln        zf_mkdir    zf_mv         zf_rm      zf_rmdir
                              \ zf_sync      pcre_compile pcre_study  pcre_match    zstat      syserror
                              \ sysopen      sysread      sysseek     syswrite      zsystem    systell
                              \ zselect      defer        zsh         abbr          zsh-defer  add-zsh-hook

syn case ignore

" syn match   zshOptStart /^\s*\%(\%(\%(un\)\?setopt\)\|set\s+[-+]o\)/ nextgroup=zshOption skipwhite
" syn match   zshOption /
"       \ \%(\%(\<no_\?\)\?aliases\>\)\|
"       \ \%(\%(\<no_\?\)\?aliasfuncdef\>\)\|\%(\%(no_\?\)\?alias_func_def\>\)\|
"       \ \%(\%(\<no_\?\)\?allexport\>\)\|\%(\%(no_\?\)\?all_export\>\)\|
"       \ \%(\%(\<no_\?\)\?alwayslastprompt\>\)\|\%(\%(no_\?\)\?always_last_prompt\>\)\|\%(\%(no_\?\)\?always_lastprompt\>\)\|
"       \ \%(\%(\<no_\?\)\?alwaystoend\>\)\|\%(\%(no_\?\)\?always_to_end\>\)\|
"       \ \%(\%(\<no_\?\)\?appendcreate\>\)\|\%(\%(no_\?\)\?append_create\>\)\|
"       \ \%(\%(\<no_\?\)\?appendhistory\>\)\|\%(\%(no_\?\)\?append_history\>\)\|
"       \ \%(\%(\<no_\?\)\?autocd\>\)\|\%(\%(no_\?\)\?auto_cd\>\)\|
"       \ \%(\%(\<no_\?\)\?autocontinue\>\)\|\%(\%(no_\?\)\?auto_continue\>\)\|
"       \ \%(\%(\<no_\?\)\?autolist\>\)\|\%(\%(no_\?\)\?auto_list\>\)\|
"       \ \%(\%(\<no_\?\)\?automenu\>\)\|\%(\%(no_\?\)\?auto_menu\>\)\|
"       \ \%(\%(\<no_\?\)\?autonamedirs\>\)\|\%(\%(no_\?\)\?auto_name_dirs\>\)\|
"       \ \%(\%(\<no_\?\)\?autoparamkeys\>\)\|\%(\%(no_\?\)\?auto_param_keys\>\)\|
"       \ \%(\%(\<no_\?\)\?autoparamslash\>\)\|\%(\%(no_\?\)\?auto_param_slash\>\)\|
"       \ \%(\%(\<no_\?\)\?autopushd\>\)\|\%(\%(no_\?\)\?auto_pushd\>\)\|
"       \ \%(\%(\<no_\?\)\?autoremoveslash\>\)\|\%(\%(no_\?\)\?auto_remove_slash\>\)\|
"       \ \%(\%(\<no_\?\)\?autoresume\>\)\|\%(\%(no_\?\)\?auto_resume\>\)\|
"       \ \%(\%(\<no_\?\)\?badpattern\>\)\|\%(\%(no_\?\)\?bad_pattern\>\)\|
"       \ \%(\%(\<no_\?\)\?banghist\>\)\|\%(\%(no_\?\)\?bang_hist\>\)\|
"       \ \%(\%(\<no_\?\)\?bareglobqual\>\)\|\%(\%(no_\?\)\?bare_glob_qual\>\)\|
"       \ \%(\%(\<no_\?\)\?bashautolist\>\)\|\%(\%(no_\?\)\?bash_auto_list\>\)\|
"       \ \%(\%(\<no_\?\)\?bashrematch\>\)\|\%(\%(no_\?\)\?bash_rematch\>\)\|
"       \ \%(\%(\<no_\?\)\?beep\>\)\|
"       \ \%(\%(\<no_\?\)\?bgnice\>\)\|\%(\%(no_\?\)\?bg_nice\>\)\|
"       \ \%(\%(\<no_\?\)\?braceccl\>\)\|\%(\%(no_\?\)\?brace_ccl\>\)\|
"       \ \%(\%(\<no_\?\)\?braceexpand\>\)\|\%(\%(no_\?\)\?brace_expand\>\)\|
"       \ \%(\%(\<no_\?\)\?bsdecho\>\)\|\%(\%(no_\?\)\?bsd_echo\>\)\|
"       \ \%(\%(\<no_\?\)\?caseglob\>\)\|\%(\%(no_\?\)\?case_glob\>\)\|
"       \ \%(\%(\<no_\?\)\?casematch\>\)\|\%(\%(no_\?\)\?case_match\>\)\|
"       \ \%(\%(\<no_\?\)\?casepaths\>\)\|\%(\%(no_\?\)\?case_paths\>\)\|
"       \ \%(\%(\<no_\?\)\?cbases\>\)\|\%(\%(no_\?\)\?c_bases\>\)\|
"       \ \%(\%(\<no_\?\)\?cdablevars\>\)\|\%(\%(no_\?\)\?cdable_vars\>\)\|\%(\%(no_\?\)\?cd_able_vars\>\)\|
"       \ \%(\%(\<no_\?\)\?cdsilent\>\)\|\%(\%(no_\?\)\?cd_silent\>\)\|\%(\%(no_\?\)\?cd_silent\>\)\|
"       \ \%(\%(\<no_\?\)\?chasedots\>\)\|\%(\%(no_\?\)\?chase_dots\>\)\|
"       \ \%(\%(\<no_\?\)\?chaselinks\>\)\|\%(\%(no_\?\)\?chase_links\>\)\|
"       \ \%(\%(\<no_\?\)\?checkjobs\>\)\|\%(\%(no_\?\)\?check_jobs\>\)\|
"       \ \%(\%(\<no_\?\)\?checkrunningjobs\>\)\|\%(\%(no_\?\)\?check_running_jobs\>\)\|
"       \ \%(\%(\<no_\?\)\?clobber\>\)\|
"       \ \%(\%(\<no_\?\)\?clobberempty\>\)\|\%(\%(no_\?\)\?clobber_empty\>\)\|
"       \ \%(\%(\<no_\?\)\?combiningchars\>\)\|\%(\%(no_\?\)\?combining_chars\>\)\|
"       \ \%(\%(\<no_\?\)\?completealiases\>\)\|\%(\%(no_\?\)\?complete_aliases\>\)\|
"       \ \%(\%(\<no_\?\)\?completeinword\>\)\|\%(\%(no_\?\)\?complete_in_word\>\)\|
"       \ \%(\%(\<no_\?\)\?continueonerror\>\)\|\%(\%(no_\?\)\?continue_on_error\>\)\|
"       \ \%(\%(\<no_\?\)\?correct\>\)\|
"       \ \%(\%(\<no_\?\)\?correctall\>\)\|\%(\%(no_\?\)\?correct_all\>\)\|
"       \ \%(\%(\<no_\?\)\?cprecedences\>\)\|\%(\%(no_\?\)\?c_precedences\>\)\|
"       \ \%(\%(\<no_\?\)\?cshjunkiehistory\>\)\|\%(\%(no_\?\)\?csh_junkie_history\>\)\|
"       \ \%(\%(\<no_\?\)\?cshjunkieloops\>\)\|\%(\%(no_\?\)\?csh_junkie_loops\>\)\|
"       \ \%(\%(\<no_\?\)\?cshjunkiequotes\>\)\|\%(\%(no_\?\)\?csh_junkie_quotes\>\)\|
"       \ \%(\%(\<no_\?\)\?csh_nullcmd\>\)\|\%(\%(no_\?\)\?csh_null_cmd\>\)\|\%(\%(no_\?\)\?cshnullcmd\>\)\|\%(\%(no_\?\)\?csh_null_cmd\>\)\|
"       \ \%(\%(\<no_\?\)\?cshnullglob\>\)\|\%(\%(no_\?\)\?csh_null_glob\>\)\|
"       \ \%(\%(\<no_\?\)\?debugbeforecmd\>\)\|\%(\%(no_\?\)\?debug_before_cmd\>\)\|
"       \ \%(\%(\<no_\?\)\?dotglob\>\)\|\%(\%(no_\?\)\?dot_glob\>\)\|
"       \ \%(\%(\<no_\?\)\?dvorak\>\)\|
"       \ \%(\%(\<no_\?\)\?emacs\>\)\|
"       \ \%(\%(\<no_\?\)\?equals\>\)\|
"       \ \%(\%(\<no_\?\)\?errexit\>\)\|\%(\%(no_\?\)\?err_exit\>\)\|
"       \ \%(\%(\<no_\?\)\?errreturn\>\)\|\%(\%(no_\?\)\?err_return\>\)\|
"       \ \%(\%(\<no_\?\)\?evallineno\>\)\|\%(\%(no_\?\)\?eval_lineno\>\)\|
"       \ \%(\%(\<no_\?\)\?exec\>\)\|
"       \ \%(\%(\<no_\?\)\?extendedglob\>\)\|\%(\%(no_\?\)\?extended_glob\>\)\|
"       \ \%(\%(\<no_\?\)\?extendedhistory\>\)\|\%(\%(no_\?\)\?extended_history\>\)\|
"       \ \%(\%(\<no_\?\)\?flowcontrol\>\)\|\%(\%(no_\?\)\?flow_control\>\)\|
"       \ \%(\%(\<no_\?\)\?forcefloat\>\)\|\%(\%(no_\?\)\?force_float\>\)\|
"       \ \%(\%(\<no_\?\)\?functionargzero\>\)\|\%(\%(no_\?\)\?function_argzero\>\)\|\%(\%(no_\?\)\?function_arg_zero\>\)\|
"       \ \%(\%(\<no_\?\)\?glob\>\)\|
"       \ \%(\%(\<no_\?\)\?globalexport\>\)\|\%(\%(no_\?\)\?global_export\>\)\|
"       \ \%(\%(\<no_\?\)\?globalrcs\>\)\|\%(\%(no_\?\)\?global_rcs\>\)\|
"       \ \%(\%(\<no_\?\)\?globassign\>\)\|\%(\%(no_\?\)\?glob_assign\>\)\|
"       \ \%(\%(\<no_\?\)\?globcomplete\>\)\|\%(\%(no_\?\)\?glob_complete\>\)\|
"       \ \%(\%(\<no_\?\)\?globdots\>\)\|\%(\%(no_\?\)\?glob_dots\>\)\|
"       \ \%(\%(\<no_\?\)\?glob_subst\>\)\|\%(\%(no_\?\)\?globsubst\>\)\|
"       \ \%(\%(\<no_\?\)\?globstarshort\>\)\|\%(\%(no_\?\)\?glob_star_short\>\)\|
"       \ \%(\%(\<no_\?\)\?hashall\>\)\|\%(\%(no_\?\)\?hash_all\>\)\|
"       \ \%(\%(\<no_\?\)\?hashcmds\>\)\|\%(\%(no_\?\)\?hash_cmds\>\)\|
"       \ \%(\%(\<no_\?\)\?hashdirs\>\)\|\%(\%(no_\?\)\?hash_dirs\>\)\|
"       \ \%(\%(\<no_\?\)\?hashexecutablesonly\>\)\|\%(\%(no_\?\)\?hash_executables_only\>\)\|
"       \ \%(\%(\<no_\?\)\?hashlistall\>\)\|\%(\%(no_\?\)\?hash_list_all\>\)\|
"       \ \%(\%(\<no_\?\)\?histallowclobber\>\)\|\%(\%(no_\?\)\?hist_allow_clobber\>\)\|
"       \ \%(\%(\<no_\?\)\?histappend\>\)\|\%(\%(no_\?\)\?hist_append\>\)\|
"       \ \%(\%(\<no_\?\)\?histbeep\>\)\|\%(\%(no_\?\)\?hist_beep\>\)\|
"       \ \%(\%(\<no_\?\)\?hist_expand\>\)\|\%(\%(no_\?\)\?histexpand\>\)\|
"       \ \%(\%(\<no_\?\)\?hist_expire_dups_first\>\)\|\%(\%(no_\?\)\?histexpiredupsfirst\>\)\|
"       \ \%(\%(\<no_\?\)\?histfcntllock\>\)\|\%(\%(no_\?\)\?hist_fcntl_lock\>\)\|
"       \ \%(\%(\<no_\?\)\?histfindnodups\>\)\|\%(\%(no_\?\)\?hist_find_no_dups\>\)\|
"       \ \%(\%(\<no_\?\)\?histignorealldups\>\)\|\%(\%(no_\?\)\?hist_ignore_all_dups\>\)\|
"       \ \%(\%(\<no_\?\)\?histignoredups\>\)\|\%(\%(no_\?\)\?hist_ignore_dups\>\)\|
"       \ \%(\%(\<no_\?\)\?histignorespace\>\)\|\%(\%(no_\?\)\?hist_ignore_space\>\)\|
"       \ \%(\%(\<no_\?\)\?histlexwords\>\)\|\%(\%(no_\?\)\?hist_lex_words\>\)\|
"       \ \%(\%(\<no_\?\)\?histnofunctions\>\)\|\%(\%(no_\?\)\?hist_no_functions\>\)\|
"       \ \%(\%(\<no_\?\)\?histnostore\>\)\|\%(\%(no_\?\)\?hist_no_store\>\)\|
"       \ \%(\%(\<no_\?\)\?histreduceblanks\>\)\|\%(\%(no_\?\)\?hist_reduce_blanks\>\)\|
"       \ \%(\%(\<no_\?\)\?histsavebycopy\>\)\|\%(\%(no_\?\)\?hist_save_by_copy\>\)\|
"       \ \%(\%(\<no_\?\)\?histsavenodups\>\)\|\%(\%(no_\?\)\?hist_save_no_dups\>\)\|
"       \ \%(\%(\<no_\?\)\?histsubstpattern\>\)\|\%(\%(no_\?\)\?hist_subst_pattern\>\)\|
"       \ \%(\%(\<no_\?\)\?histverify\>\)\|\%(\%(no_\?\)\?hist_verify\>\)\|
"       \ \%(\%(\<no_\?\)\?hup\>\)\|
"       \ \%(\%(\<no_\?\)\?ignorebraces\>\)\|\%(\%(no_\?\)\?ignore_braces\>\)\|
"       \ \%(\%(\<no_\?\)\?ignoreclosebraces\>\)\|\%(\%(no_\?\)\?ignore_close_braces\>\)\|
"       \ \%(\%(\<no_\?\)\?ignoreeof\>\)\|\%(\%(no_\?\)\?ignore_eof\>\)\|
"       \ \%(\%(\<no_\?\)\?incappendhistory\>\)\|\%(\%(no_\?\)\?inc_append_history\>\)\|
"       \ \%(\%(\<no_\?\)\?incappendhistorytime\>\)\|\%(\%(no_\?\)\?inc_append_history_time\>\)\|
"       \ \%(\%(\<no_\?\)\?interactive\>\)\|
"       \ \%(\%(\<no_\?\)\?interactivecomments\>\)\|\%(\%(no_\?\)\?interactive_comments\>\)\|
"       \ \%(\%(\<no_\?\)\?ksharrays\>\)\|\%(\%(no_\?\)\?ksh_arrays\>\)\|
"       \ \%(\%(\<no_\?\)\?kshautoload\>\)\|\%(\%(no_\?\)\?ksh_autoload\>\)\|
"       \ \%(\%(\<no_\?\)\?kshglob\>\)\|\%(\%(no_\?\)\?ksh_glob\>\)\|
"       \ \%(\%(\<no_\?\)\?kshoptionprint\>\)\|\%(\%(no_\?\)\?ksh_option_print\>\)\|
"       \ \%(\%(\<no_\?\)\?kshtypeset\>\)\|\%(\%(no_\?\)\?ksh_typeset\>\)\|
"       \ \%(\%(\<no_\?\)\?kshzerosubscript\>\)\|\%(\%(no_\?\)\?ksh_zero_subscript\>\)\|
"       \ \%(\%(\<no_\?\)\?listambiguous\>\)\|\%(\%(no_\?\)\?list_ambiguous\>\)\|
"       \ \%(\%(\<no_\?\)\?listbeep\>\)\|\%(\%(no_\?\)\?list_beep\>\)\|
"       \ \%(\%(\<no_\?\)\?listpacked\>\)\|\%(\%(no_\?\)\?list_packed\>\)\|
"       \ \%(\%(\<no_\?\)\?listrowsfirst\>\)\|\%(\%(no_\?\)\?list_rows_first\>\)\|
"       \ \%(\%(\<no_\?\)\?listtypes\>\)\|\%(\%(no_\?\)\?list_types\>\)\|
"       \ \%(\%(\<no_\?\)\?localloops\>\)\|\%(\%(no_\?\)\?local_loops\>\)\|
"       \ \%(\%(\<no_\?\)\?localoptions\>\)\|\%(\%(no_\?\)\?local_options\>\)\|
"       \ \%(\%(\<no_\?\)\?localpatterns\>\)\|\%(\%(no_\?\)\?local_patterns\>\)\|
"       \ \%(\%(\<no_\?\)\?localtraps\>\)\|\%(\%(no_\?\)\?local_traps\>\)\|
"       \ \%(\%(\<no_\?\)\?log\>\)\|
"       \ \%(\%(\<no_\?\)\?login\>\)\|
"       \ \%(\%(\<no_\?\)\?longlistjobs\>\)\|\%(\%(no_\?\)\?long_list_jobs\>\)\|
"       \ \%(\%(\<no_\?\)\?magicequalsubst\>\)\|\%(\%(no_\?\)\?magic_equal_subst\>\)\|
"       \ \%(\%(\<no_\?\)\?mark_dirs\>\)\|
"       \ \%(\%(\<no_\?\)\?mailwarn\>\)\|\%(\%(no_\?\)\?mail_warn\>\)\|
"       \ \%(\%(\<no_\?\)\?mailwarning\>\)\|\%(\%(no_\?\)\?mail_warning\>\)\|
"       \ \%(\%(\<no_\?\)\?markdirs\>\)\|
"       \ \%(\%(\<no_\?\)\?menucomplete\>\)\|\%(\%(no_\?\)\?menu_complete\>\)\|
"       \ \%(\%(\<no_\?\)\?monitor\>\)\|
"       \ \%(\%(\<no_\?\)\?multibyte\>\)\|\%(\%(no_\?\)\?multi_byte\>\)\|
"       \ \%(\%(\<no_\?\)\?multifuncdef\>\)\|\%(\%(no_\?\)\?multi_func_def\>\)\|
"       \ \%(\%(\<no_\?\)\?multios\>\)\|\%(\%(no_\?\)\?multi_os\>\)\|
"       \ \%(\%(\<no_\?\)\?nomatch\>\)\|\%(\%(no_\?\)\?no_match\>\)\|
"       \ \%(\%(\<no_\?\)\?notify\>\)\|
"       \ \%(\%(\<no_\?\)\?nullglob\>\)\|\%(\%(no_\?\)\?null_glob\>\)\|
"       \ \%(\%(\<no_\?\)\?numericglobsort\>\)\|\%(\%(no_\?\)\?numeric_glob_sort\>\)\|
"       \ \%(\%(\<no_\?\)\?octalzeroes\>\)\|\%(\%(no_\?\)\?octal_zeroes\>\)\|
"       \ \%(\%(\<no_\?\)\?onecmd\>\)\|\%(\%(no_\?\)\?one_cmd\>\)\|
"       \ \%(\%(\<no_\?\)\?overstrike\>\)\|\%(\%(no_\?\)\?over_strike\>\)\|
"       \ \%(\%(\<no_\?\)\?pathdirs\>\)\|\%(\%(no_\?\)\?path_dirs\>\)\|
"       \ \%(\%(\<no_\?\)\?pathscript\>\)\|\%(\%(no_\?\)\?path_script\>\)\|
"       \ \%(\%(\<no_\?\)\?physical\>\)\|
"       \ \%(\%(\<no_\?\)\?pipefail\>\)\|\%(\%(no_\?\)\?pipe_fail\>\)\|
"       \ \%(\%(\<no_\?\)\?posixaliases\>\)\|\%(\%(no_\?\)\?posix_aliases\>\)\|
"       \ \%(\%(\<no_\?\)\?posixargzero\>\)\|\%(\%(no_\?\)\?posix_arg_zero\>\)\|\%(\%(no_\?\)\?posix_argzero\>\)\|
"       \ \%(\%(\<no_\?\)\?posixbuiltins\>\)\|\%(\%(no_\?\)\?posix_builtins\>\)\|
"       \ \%(\%(\<no_\?\)\?posixcd\>\)\|\%(\%(no_\?\)\?posix_cd\>\)\|
"       \ \%(\%(\<no_\?\)\?posixidentifiers\>\)\|\%(\%(no_\?\)\?posix_identifiers\>\)\|
"       \ \%(\%(\<no_\?\)\?posixjobs\>\)\|\%(\%(no_\?\)\?posix_jobs\>\)\|
"       \ \%(\%(\<no_\?\)\?posixstrings\>\)\|\%(\%(no_\?\)\?posix_strings\>\)\|
"       \ \%(\%(\<no_\?\)\?posixtraps\>\)\|\%(\%(no_\?\)\?posix_traps\>\)\|
"       \ \%(\%(\<no_\?\)\?printeightbit\>\)\|\%(\%(no_\?\)\?print_eight_bit\>\)\|
"       \ \%(\%(\<no_\?\)\?printexitvalue\>\)\|\%(\%(no_\?\)\?print_exit_value\>\)\|
"       \ \%(\%(\<no_\?\)\?privileged\>\)\|
"       \ \%(\%(\<no_\?\)\?promptbang\>\)\|\%(\%(no_\?\)\?prompt_bang\>\)\|
"       \ \%(\%(\<no_\?\)\?promptcr\>\)\|\%(\%(no_\?\)\?prompt_cr\>\)\|
"       \ \%(\%(\<no_\?\)\?promptpercent\>\)\|\%(\%(no_\?\)\?prompt_percent\>\)\|
"       \ \%(\%(\<no_\?\)\?promptsp\>\)\|\%(\%(no_\?\)\?prompt_sp\>\)\|
"       \ \%(\%(\<no_\?\)\?promptsubst\>\)\|\%(\%(no_\?\)\?prompt_subst\>\)\|
"       \ \%(\%(\<no_\?\)\?promptvars\>\)\|\%(\%(no_\?\)\?prompt_vars\>\)\|
"       \ \%(\%(\<no_\?\)\?pushdignoredups\>\)\|\%(\%(no_\?\)\?pushd_ignore_dups\>\)\|
"       \ \%(\%(\<no_\?\)\?pushdminus\>\)\|\%(\%(no_\?\)\?pushd_minus\>\)\|
"       \ \%(\%(\<no_\?\)\?pushdsilent\>\)\|\%(\%(no_\?\)\?pushd_silent\>\)\|
"       \ \%(\%(\<no_\?\)\?pushdtohome\>\)\|\%(\%(no_\?\)\?pushd_to_home\>\)\|
"       \ \%(\%(\<no_\?\)\?rcexpandparam\>\)\|\%(\%(no_\?\)\?rc_expandparam\>\)\|\%(\%(no_\?\)\?rc_expand_param\>\)\|
"       \ \%(\%(\<no_\?\)\?rcquotes\>\)\|\%(\%(no_\?\)\?rc_quotes\>\)\|
"       \ \%(\%(\<no_\?\)\?rcs\>\)\|
"       \ \%(\%(\<no_\?\)\?recexact\>\)\|\%(\%(no_\?\)\?rec_exact\>\)\|
"       \ \%(\%(\<no_\?\)\?rematchpcre\>\)\|\%(\%(no_\?\)\?re_match_pcre\>\)\|\%(\%(no_\?\)\?rematch_pcre\>\)\|
"       \ \%(\%(\<no_\?\)\?restricted\>\)\|
"       \ \%(\%(\<no_\?\)\?rmstarsilent\>\)\|\%(\%(no_\?\)\?rm_star_silent\>\)\|
"       \ \%(\%(\<no_\?\)\?rmstarwait\>\)\|\%(\%(no_\?\)\?rm_star_wait\>\)\|
"       \ \%(\%(\<no_\?\)\?sharehistory\>\)\|\%(\%(no_\?\)\?share_history\>\)\|
"       \ \%(\%(\<no_\?\)\?shfileexpansion\>\)\|\%(\%(no_\?\)\?sh_file_expansion\>\)\|
"       \ \%(\%(\<no_\?\)\?shglob\>\)\|\%(\%(no_\?\)\?sh_glob\>\)\|
"       \ \%(\%(\<no_\?\)\?shinstdin\>\)\|\%(\%(no_\?\)\?shin_stdin\>\)\|
"       \ \%(\%(\<no_\?\)\?shnullcmd\>\)\|\%(\%(no_\?\)\?sh_nullcmd\>\)\|
"       \ \%(\%(\<no_\?\)\?shoptionletters\>\)\|\%(\%(no_\?\)\?sh_option_letters\>\)\|
"       \ \%(\%(\<no_\?\)\?shortloops\>\)\|\%(\%(no_\?\)\?short_loops\>\)\|
"       \ \%(\%(\<no_\?\)\?shortrepeat\>\)\|\%(\%(no_\?\)\?short_repeat\>\)\|
"       \ \%(\%(\<no_\?\)\?shwordsplit\>\)\|\%(\%(no_\?\)\?sh_word_split\>\)\|
"       \ \%(\%(\<no_\?\)\?singlecommand\>\)\|\%(\%(no_\?\)\?single_command\>\)\|
"       \ \%(\%(\<no_\?\)\?singlelinezle\>\)\|\%(\%(no_\?\)\?single_line_zle\>\)\|
"       \ \%(\%(\<no_\?\)\?sourcetrace\>\)\|\%(\%(no_\?\)\?source_trace\>\)\|
"       \ \%(\%(\<no_\?\)\?stdin\>\)\|
"       \ \%(\%(\<no_\?\)\?sunkeyboardhack\>\)\|\%(\%(no_\?\)\?sun_keyboard_hack\>\)\|
"       \ \%(\%(\<no_\?\)\?trackall\>\)\|\%(\%(no_\?\)\?track_all\>\)\|
"       \ \%(\%(\<no_\?\)\?transientrprompt\>\)\|\%(\%(no_\?\)\?transient_rprompt\>\)\|
"       \ \%(\%(\<no_\?\)\?trapsasync\>\)\|\%(\%(no_\?\)\?traps_async\>\)\|
"       \ \%(\%(\<no_\?\)\?typesetsilent\>\)\|\%(\%(no_\?\)\?type_set_silent\>\)\|\%(\%(no_\?\)\?typeset_silent\>\)\|
"       \ \%(\%(\<no_\?\)\?typesettounset\>\)\|\%(\%(no_\?\)\?type_set_to_unset\>\)\|\%(\%(no_\?\)\?typeset_to_unset\>\)\|
"       \ \%(\%(\<no_\?\)\?unset\>\)\|
"       \ \%(\%(\<no_\?\)\?verbose\>\)\|
"       \ \%(\%(\<no_\?\)\?vi\>\)\|
"       \ \%(\%(\<no_\?\)\?warnnestedvar\>\)\|\%(\%(no_\?\)\?warn_nested_var\>\)\|
"       \ \%(\%(\<no_\?\)\?warncreateglobal\>\)\|\%(\%(no_\?\)\?warn_create_global\>\)\|
"       \ \%(\%(\<no_\?\)\?xtrace\>\)\|
"       \ \%(\%(\<no_\?\)\?zle\>\)/ nextgroup=zshOption,zshComment skipwhite contained

syn match   zshOptStart
            \ /\v^\s*%(%(un)?setopt|set\s+[-+]o)/
            \ nextgroup=zshOption skipwhite
syn keyword zshOption nextgroup=zshOption,zshComment skipwhite contained
           \ auto_cd no_auto_cd autocd noautocd auto_pushd no_auto_pushd autopushd noautopushd cdable_vars
           \ no_cdable_vars cdablevars nocdablevars cd_silent no_cd_silent cdsilent nocdsilent chase_dots
           \ no_chase_dots chasedots nochasedots chase_links no_chase_links chaselinks nochaselinks posix_cd
           \ posixcd no_posix_cd noposixcd pushd_ignore_dups no_pushd_ignore_dups pushdignoredups
           \ nopushdignoredups pushd_minus no_pushd_minus pushdminus nopushdminus pushd_silent no_pushd_silent
           \ pushdsilent nopushdsilent pushd_to_home no_pushd_to_home pushdtohome nopushdtohome
           \ always_last_prompt no_always_last_prompt alwayslastprompt noalwayslastprompt always_to_end
           \ no_always_to_end alwaystoend noalwaystoend auto_list no_auto_list autolist noautolist auto_menu
           \ no_auto_menu automenu noautomenu auto_name_dirs no_auto_name_dirs autonamedirs noautonamedirs
           \ auto_param_keys no_auto_param_keys autoparamkeys noautoparamkeys auto_param_slash
           \ no_auto_param_slash autoparamslash noautoparamslash auto_remove_slash no_auto_remove_slash
           \ autoremoveslash noautoremoveslash bash_auto_list no_bash_auto_list bashautolist nobashautolist
           \ complete_aliases no_complete_aliases completealiases nocompletealiases complete_in_word
           \ no_complete_in_word completeinword nocompleteinword glob_complete no_glob_complete globcomplete
           \ noglobcomplete hash_list_all no_hash_list_all hashlistall nohashlistall list_ambiguous
           \ no_list_ambiguous listambiguous nolistambiguous list_beep no_list_beep listbeep nolistbeep
           \ list_packed no_list_packed listpacked nolistpacked list_rows_first no_list_rows_first listrowsfirst
           \ nolistrowsfirst list_types no_list_types listtypes nolisttypes menu_complete no_menu_complete
           \ menucomplete nomenucomplete rec_exact no_rec_exact recexact norecexact bad_pattern no_bad_pattern
           \ badpattern nobadpattern bare_glob_qual no_bare_glob_qual bareglobqual nobareglobqual brace_ccl
           \ no_brace_ccl braceccl nobraceccl case_glob no_case_glob caseglob nocaseglob case_match
           \ no_case_match casematch nocasematch case_paths no_case_paths casepaths nocasepaths csh_null_glob
           \ no_csh_null_glob cshnullglob nocshnullglob equals no_equals noequals extended_glob no_extended_glob
           \ extendedglob noextendedglob force_float no_force_float forcefloat noforcefloat glob no_glob noglob
           \ glob_assign no_glob_assign globassign noglobassign glob_dots no_glob_dots globdots noglobdots
           \ glob_star_short no_glob_star_short globstarshort noglobstarshort glob_subst no_glob_subst globsubst
           \ noglobsubst hist_subst_pattern no_hist_subst_pattern histsubstpattern nohistsubstpattern
           \ ignore_braces no_ignore_braces ignorebraces noignorebraces ignore_close_braces
           \ no_ignore_close_braces ignoreclosebraces noignoreclosebraces ksh_glob no_ksh_glob kshglob nokshglob
           \ magic_equal_subst no_magic_equal_subst magicequalsubst nomagicequalsubst mark_dirs no_mark_dirs
           \ markdirs nomarkdirs multibyte no_multibyte nomultibyte nomatch no_nomatch nonomatch null_glob
           \ no_null_glob nullglob nonullglob numeric_glob_sort no_numeric_glob_sort numericglobsort
           \ nonumericglobsort rc_expand_param no_rc_expand_param rcexpandparam norcexpandparam rematch_pcre
           \ no_rematch_pcre rematchpcre norematchpcre sh_glob no_sh_glob shglob noshglob unset no_unset nounset
           \ warn_create_global no_warn_create_global warncreateglobal nowarncreateglobal warn_nested_var
           \ no_warn_nested_var warnnestedvar no_warnnestedvar append_history no_append_history appendhistory
           \ noappendhistory bang_hist no_bang_hist banghist nobanghist extended_history no_extended_history
           \ extendedhistory noextendedhistory hist_allow_clobber no_hist_allow_clobber histallowclobber
           \ nohistallowclobber hist_beep no_hist_beep histbeep nohistbeep hist_expire_dups_first
           \ no_hist_expire_dups_first histexpiredupsfirst nohistexpiredupsfirst hist_fcntl_lock
           \ no_hist_fcntl_lock histfcntllock nohistfcntllock hist_find_no_dups no_hist_find_no_dups
           \ histfindnodups nohistfindnodups hist_ignore_all_dups no_hist_ignore_all_dups histignorealldups
           \ nohistignorealldups hist_ignore_dups no_hist_ignore_dups histignoredups nohistignoredups
           \ hist_ignore_space no_hist_ignore_space histignorespace nohistignorespace hist_lex_words
           \ no_hist_lex_words histlexwords nohistlexwords hist_no_functions no_hist_no_functions
           \ histnofunctions nohistnofunctions hist_no_store no_hist_no_store histnostore nohistnostore
           \ hist_reduce_blanks no_hist_reduce_blanks histreduceblanks nohistreduceblanks hist_save_by_copy
           \ no_hist_save_by_copy histsavebycopy nohistsavebycopy hist_save_no_dups no_hist_save_no_dups
           \ histsavenodups nohistsavenodups hist_verify no_hist_verify histverify nohistverify
           \ inc_append_history no_inc_append_history incappendhistory noincappendhistory
           \ inc_append_history_time no_inc_append_history_time incappendhistorytime noincappendhistorytime
           \ share_history no_share_history sharehistory nosharehistory all_export no_all_export allexport
           \ noallexport global_export no_global_export globalexport noglobalexport global_rcs no_global_rcs
           \ globalrcs noglobalrcs rcs no_rcs norcs aliases no_aliases noaliases clobber no_clobber noclobber
           \ clobber_empty no_clobber_empty clobberempty noclobberempty correct no_correct nocorrect correct_all
           \ no_correct_all correctall nocorrectall dvorak no_dvorak nodvorak flow_control no_flow_control
           \ flowcontrol noflowcontrol ignore_eof no_ignore_eof ignoreeof noignoreeof interactive_comments
           \ no_interactive_comments interactivecomments nointeractivecomments hash_cmds no_hash_cmds hashcmds
           \ nohashcmds hash_dirs no_hash_dirs hashdirs nohashdirs hash_executables_only
           \ no_hash_executables_only hashexecutablesonly nohashexecutablesonly mail_warning no_mail_warning
           \ mailwarning nomailwarning path_dirs no_path_dirs pathdirs nopathdirs path_script no_path_script
           \ pathscript nopathscript print_eight_bit no_print_eight_bit printeightbit noprinteightbit
           \ print_exit_value no_print_exit_value printexitvalue noprintexitvalue rc_quotes no_rc_quotes
           \ rcquotes norcquotes rm_star_silent no_rm_star_silent rmstarsilent normstarsilent rm_star_wait
           \ no_rm_star_wait rmstarwait normstarwait short_loops no_short_loops shortloops noshortloops
           \ short_repeat no_short_repeat shortrepeat noshortrepeat sun_keyboard_hack no_sun_keyboard_hack
           \ sunkeyboardhack nosunkeyboardhack auto_continue no_auto_continue autocontinue noautocontinue
           \ auto_resume no_auto_resume autoresume noautoresume bg_nice no_bg_nice bgnice nobgnice check_jobs
           \ no_check_jobs checkjobs nocheckjobs check_running_jobs no_check_running_jobs checkrunningjobs
           \ nocheckrunningjobs hup no_hup nohup long_list_jobs no_long_list_jobs longlistjobs nolonglistjobs
           \ monitor no_monitor nomonitor notify no_notify nonotify posix_jobs posixjobs no_posix_jobs
           \ noposixjobs prompt_bang no_prompt_bang promptbang nopromptbang prompt_cr no_prompt_cr promptcr
           \ nopromptcr prompt_sp no_prompt_sp promptsp nopromptsp prompt_percent no_prompt_percent
           \ promptpercent nopromptpercent prompt_subst no_prompt_subst promptsubst nopromptsubst
           \ transient_rprompt no_transient_rprompt transientrprompt notransientrprompt alias_func_def
           \ no_alias_func_def aliasfuncdef noaliasfuncdef c_bases no_c_bases cbases nocbases c_precedences
           \ no_c_precedences cprecedences nocprecedences debug_before_cmd no_debug_before_cmd debugbeforecmd
           \ nodebugbeforecmd err_exit no_err_exit errexit noerrexit err_return no_err_return errreturn
           \ noerrreturn eval_lineno no_eval_lineno evallineno noevallineno exec no_exec noexec function_argzero
           \ no_function_argzero functionargzero nofunctionargzero local_loops no_local_loops localloops
           \ nolocalloops local_options no_local_options localoptions nolocaloptions local_patterns
           \ no_local_patterns localpatterns nolocalpatterns local_traps no_local_traps localtraps nolocaltraps
           \ multi_func_def no_multi_func_def multifuncdef nomultifuncdef multios no_multios nomultios
           \ octal_zeroes no_octal_zeroes octalzeroes nooctalzeroes pipe_fail no_pipe_fail pipefail nopipefail
           \ source_trace no_source_trace sourcetrace nosourcetrace typeset_silent no_typeset_silent
           \ typesetsilent notypesetsilent typeset_to_unset no_typeset_to_unset typesettounset notypesettounset
           \ verbose no_verbose noverbose xtrace no_xtrace noxtrace append_create no_append_create appendcreate
           \ noappendcreate bash_rematch no_bash_rematch bashrematch nobashrematch bsd_echo no_bsd_echo bsdecho
           \ nobsdecho continue_on_error no_continue_on_error continueonerror nocontinueonerror
           \ csh_junkie_history no_csh_junkie_history cshjunkiehistory nocshjunkiehistory csh_junkie_loops
           \ no_csh_junkie_loops cshjunkieloops nocshjunkieloops csh_junkie_quotes no_csh_junkie_quotes
           \ cshjunkiequotes nocshjunkiequotes csh_nullcmd no_csh_nullcmd cshnullcmd nocshnullcmd ksh_arrays
           \ no_ksh_arrays ksharrays noksharrays ksh_autoload no_ksh_autoload kshautoload nokshautoload
           \ ksh_option_print no_ksh_option_print kshoptionprint nokshoptionprint ksh_typeset no_ksh_typeset
           \ kshtypeset nokshtypeset ksh_zero_subscript no_ksh_zero_subscript kshzerosubscript
           \ nokshzerosubscript posix_aliases no_posix_aliases posixaliases noposixaliases posix_argzero
           \ no_posix_argzero posixargzero noposixargzero posix_builtins no_posix_builtins posixbuiltins
           \ noposixbuiltins posix_identifiers no_posix_identifiers posixidentifiers noposixidentifiers
           \ posix_strings no_posix_strings posixstrings noposixstrings posix_traps no_posix_traps posixtraps
           \ noposixtraps sh_file_expansion no_sh_file_expansion shfileexpansion noshfileexpansion sh_nullcmd
           \ no_sh_nullcmd shnullcmd noshnullcmd sh_option_letters no_sh_option_letters shoptionletters
           \ noshoptionletters sh_word_split no_sh_word_split shwordsplit noshwordsplit traps_async
           \ no_traps_async trapsasync notrapsasync interactive no_interactive nointeractive login no_login
           \ nologin privileged no_privileged noprivileged restricted no_restricted norestricted shin_stdin
           \ no_shin_stdin shinstdin noshinstdin single_command no_single_command singlecommand nosinglecommand
           \ beep no_beep nobeep combining_chars no_combining_chars combiningchars nocombiningchars emacs
           \ no_emacs noemacs overstrike no_overstrike nooverstrike single_line_zle no_single_line_zle
           \ singlelinezle nosinglelinezle vi no_vi novi zle no_zle nozle brace_expand no_brace_expand
           \ braceexpand nobraceexpand dot_glob no_dot_glob dotglob nodotglob hash_all no_hash_all hashall
           \ nohashall hist_append no_hist_append histappend nohistappend hist_expand no_hist_expand histexpand
           \ nohistexpand log no_log nolog mail_warn no_mail_warn mailwarn nomailwarn one_cmd no_one_cmd onecmd
           \ noonecmd physical no_physical nophysical prompt_vars no_prompt_vars promptvars nopromptvars stdin
           \ no_stdin nostdin track_all no_track_all trackall notrackall

syn case match

syn keyword zshTypes            float integer local typeset declare private readonly

" XXX: this may be too much
" syn match   zshSwitches         '\s\zs--\=[a-zA-Z0-9-]\+'

" TODO: $[...] is the same as $((...)), so add that as well.
syn cluster zshSubst            contains=zshSubst,zshOldSubst,zshMathSubst
syn cluster zshSubstQuoted      contains=zshSubstQuoted,zshOldSubst,zshMathSubst
exe 'syn region  zshSubst       matchgroup=zshSubstDelim transparent start=/\$(/ skip=/\\)/ end=/)/ contains='.s:contained. '  fold'
exe 'syn region  zshSubstQuoted matchgroup=zshSubstDelim transparent start=/\$(/ skip=/\\)/ end=/)/ contains='.s:contained. '  fold'
syn region  zshSubstQuoted      matchgroup=zshSubstDelim start='\${' skip='\\}' end='}' contains=@zshSubst,zshBrackets,zshQuoted fold
syn region  zshParentheses      transparent start='(' skip='\\)' end=')' fold
syn region  zshGlob             start='(#' end=')'
syn region  zshMathSubst        matchgroup=zshSubstDelim transparent
                                \ start='\%(\$\?\)[<=>]\@<!((' skip='\\)' end='))'
                                \ contains=zshParentheses,@zshSubst,zshNumber,
                                \ @zshDerefs,zshString fold
" The ms=s+1 prevents matching zshBrackets several times on opening brackets
" (see https://github.com/chrisbra/vim-zsh/issues/21#issuecomment-576330348)
syn region  zshBrackets         contained transparent start='{'ms=s+1 skip='\\}'
                                \ end='}' fold
exe 'syn region  zshBrackets    transparent start=/{/ms=s+1 skip=/\\}/ end=/}/ contains='.s:contained. ' fold'

syn region  zshSubst            matchgroup=zshSubstDelim start='\${' skip='\\}'
                                \ end='}' contains=@zshSubst,zshBrackets,zshQuoted,zshString fold
exe 'syn region  zshOldSubst    matchgroup=zshSubstDelim start=/`/ skip=/\\[\\`]/ end=/`/ contains='.s:contained. ',zshOldSubst fold'

syn sync    minlines=50 maxlines=90
syn sync    match zshHereDocSync    grouphere   NONE '<<-\=\s*\%(\\\=\S\+\|\(["']\)\S\+\1\)'
syn sync    match zshHereDocEndSync groupthere  NONE '^\s*EO\a\+\>'

syn keyword zshTodo             contained TODO FIXME XXX NOTE

syn region  zshComment          oneline start='\%(^\|\s\+\)#' end='$'
                                \ contains=zshTodo,@Spell fold

syn region  zshComment          start='^\s*#' end='^\%(\s*#\)\@!'
                                \ contains=zshTodo,@Spell fold

syn match   zshPreProc          '^\%1l#\%(!\|compdef\|autoload\).*$'

hi def link zshTodo             Todo
hi def link zshComment          Comment
hi def link zshPreProc          PreProc
hi def link zshQuoted           SpecialChar
hi def link zshPOSIXQuoted      SpecialChar
hi def link zshString           String
hi def link zshStringDelimiter  zshString
hi def link zshPOSIXString      zshString
hi def link zshJobSpec          Special
hi def link zshPrecommand       Special
hi def link zshDelimiter        Keyword
hi def link zshConditional      Conditional
hi def link zshCase             zshConditional
hi def link zshCaseIn           zshCase
hi def link zshException        Exception
hi def link zshRepeat           Repeat
hi def link zshKeyword          Keyword
hi def link zshFunction         None
hi def link zshKSHFunction      zshFunction
hi def link zshHereDoc          String
hi def link zshOperator         None
hi def link zshRedir            Operator
hi def link zshVariable         None
hi def link zshVariableDef      zshVariable
hi def link zshDereferencing    PreProc
hi def link zshShortDeref       zshDereferencing
hi def link zshLongDeref        zshDereferencing
hi def link zshDeref            zshDereferencing
hi def link zshDollarVar        zshDereferencing
hi def link zshCommands         Keyword
hi def link zshOptStart         Keyword
hi def link zshOption           Constant
hi def link zshTypes            Type
hi def link zshSwitches         Special
hi def link zshNumber           Number
hi def link zshSubst            PreProc
hi def link zshSubstQuoted      zshSubst
hi def link zshMathSubst        zshSubst
hi def link zshOldSubst         zshSubst
hi def link zshSubstDelim       zshSubst
hi def link zshGlob             zshSubst

let b:current_syntax = "zsh"

let &cpo = s:cpo_save
unlet s:cpo_save
