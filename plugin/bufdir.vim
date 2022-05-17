let s:dir_when_launched = getcwd()

function! s:get_current_buffer_directory()
    "See h: filename-modifiers
    let directory_of_buffer = expand("%:p")
    if directory_of_buffer == ""
        let directory_of_buffer = getcwd()
    elseif (!isdirectory(directory_of_buffer))
        "Then it's a full filepath. Drop the filename to get the directory.
        let directory_of_buffer = expand("%:p:h")
    endif
    return directory_of_buffer
endfunction

function! s:handle_bufdir_command(commands)
    let directory_of_buffer = s:get_current_buffer_directory()

    if a:commands == ""
        echo directory_of_buffer
        return
    endif

    let original_directory = getcwd()
    execute "cd" directory_of_buffer
    execute a:commands
    execute "cd" original_directory
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

command! -bar -bang -nargs=* Bufdir call <SID>handle_bufdir_command(<q-args>)
command! -bar -bang -nargs=0 Chbufdir call <SID>handle_chbufdir_command()
command! -bar -bang -nargs=0 Chlaunchdir call <SID>handle_chlaunchdir_command()
command! -bar -bang -nargs=* Launchdir call <SID>handle_launchdir_command(<q-args>)
command! -bar -bang -nargs=0 Resetlaunchdir call <SID>handle_resetlaunchdir_command()

