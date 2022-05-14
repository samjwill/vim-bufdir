let s:dir_when_launched = getcwd()

function! s:get_pre_and_postbar_args(args_list)
    let bar_encountered = 0
    "TODO: Rename vvv
    let prebar_cmds = ""
    let postbar_cmds = ""

    for arg in a:args_list
        if (arg == "|" && bar_encountered == 0)
            let bar_encountered = 1
        elseif (bar_encountered == 0)
            let prebar_cmds = prebar_cmds . arg
        elseif (bar_encountered == 1)
            let postbar_cmds = postbar_cmds . arg
        endif
    endfor

    return [prebar_cmds, postbar_cmds]
endfunction

function! s:get_current_buffer_directory()
    "See h: filename-modifiers
    let directory_of_buffer = expand("%:p")
    if directory_of_buffer == ""
        let directory_of_buffer = getcwd()
    endif
    if (!isdirectory(directory_of_buffer))
        "Then it's a full filepath. Drop the filename to get the directory.
        let directory_of_buffer = expand("%:p:h")
    endif
    return directory_of_buffer
endfunction

function! s:handle_bufdir_command(...)
    let args_list = s:get_pre_and_postbar_args(a:000)
    let prebar_cmds = args_list[0]
    let postbar_cmds = args_list[1]

    let directory_of_buffer = s:get_current_buffer_directory()

    if (prebar_cmds == "")
        echo directory_of_buffer
    else
        let original_directory = getcwd()
        execute "cd" directory_of_buffer
        execute prebar_cmds
        execute "cd" original_directory
    endif

    if (!(postbar_cmds == ""))
        execute postbar_cmds
    endif
endfunction

function! s:handle_chbufdir_command()
    let directory_of_buffer = s:get_current_buffer_directory()
    execute "cd" directory_of_buffer
endfunction

function! s:handle_chlaunchdir_command()
    execute "cd" s:dir_when_launched
endfunction

function! s:handle_launchdir_command(commands)
    if a:commands == ""
        echo s:dir_when_launched
        return
    endif

    let original_directory = getcwd()
    execute "cd" s:dir_when_launched
    execute a:commands
    execute "cd" original_directory
endfunction

function! s:handle_resetlaunchdir_command()
    let s:dir_when_launched = getcwd()
endfunction

command! -nargs=* Bufdir call <SID>handle_bufdir_command(<f-args>)
command! -nargs=0 Chbufdir call <SID>handle_chbufdir_command()
command! -nargs=0 Chlaunchdir call <SID>handle_chlaunchdir_command()
command! -nargs=* Launchdir call <SID>handle_launchdir_command(<q-args>)
command! -nargs=0 Resetlaunchdir call <SID>handle_resetlaunchdir_command()

