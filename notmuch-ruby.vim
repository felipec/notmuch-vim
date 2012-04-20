if exists("g:loaded_notmuch_rb")
	finish
endif

if !has("ruby") || version < 700
	finish
endif

let g:loaded_notmuch_rb = "yep"

let s:notmuch_rb_folders_default = [
	\ [ 'new', 'tag:inbox and tag:unread' ],
	\ [ 'inbox', 'tag:inbox' ],
	\ [ 'unread', 'tag:unread' ],
	\ ]

if !exists('g:notmuch_rb_folders')
	let g:notmuch_rb_folders = s:notmuch_rb_folders_default
endif

function! s:NM_new_buffer(type)
	enew
	setlocal buftype=nofile bufhidden=hide
	keepjumps 0d
	execute printf('set filetype=notmuch-%s', a:type)
	execute printf('set syntax=notmuch-%s', a:type)
endfunction

function! s:NM_set_menu_buffer()
	setlocal nomodifiable
	setlocal cursorline
	setlocal nowrap
endfunction

function! s:NM_folders()
	call <SID>NM_new_buffer('folders')
ruby << EOF
	VIM::Buffer::current.render do |b|
		folders = VIM::evaluate('g:notmuch_rb_folders')
		folders.each do |name, search|
			q = $db.query(search)
			b << "%9d %-20s (%s)" % [q.search_threads.count, name, search]
		end
	end
EOF
	call <SID>NM_set_menu_buffer()
endfunction

function! s:NotMuchR()
ruby << EOF
	require 'notmuch'
	$db = Notmuch::Database.new(VIM::evaluate('g:notmuch_rb_database'))
	class VIM::Buffer
		def <<(a)
			append(count(), a)
		end
		def render
			yield self
			delete(1)
		end
	end
EOF
	call <SID>NM_folders()
endfunction

command NotMuchR :call <SID>NotMuchR()
