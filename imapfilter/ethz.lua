----------------------------------------------
-- This is the configuration file for my ETHZ
-- account.  I'm separating out my configuration
-- for each account so I can call instances of
-- imapfilter for each account individually.
----------------------------------------------

function trim(s)
    -- from PiL2 20.4
    return (s:gsub("^%s*(.-)%s*$", "%1"))
end


-------------
-- Options --
-------------
options.timeout = 60
options.subscribe = true
options.namespace = false
options.create = true

-- for debugging purposes
options.info = true

-- Accounts

status, myuser = pipe_from('~/.mail_config/lib/imapfilter-helper.py mail.ethz.ch user')

myuser = trim(myuser)

status, mypass = pipe_from('~/.mail_config/lib/imapfilter-helper.py mail.ethz.ch password')
mypass = trim(mypass)

EECS = IMAP {
	server = 'mail.ethz.ch',
	username = myuser,
	password = mypass,
	ssl = 'ssl3'
}

-- Functions
-- none

-- Filters
-- * implements logical and
-- + implements logical or
-- - implements logical not

-- Get some basic tables loaded so we can just look at those
-- rather than searching the mailbox multiple times
recent = EECS.INBOX:is_recent()
all = EECS.INBOX:select_all()


-- Mark all the new messages that I've sent as read
msgs = recent:contain_from(myuser) *
       recent:is_new()
EECS.INBOX:mark_seen(msgs)

--------------------------------------------------
-- Move Math 501 emails to their own folder.
-- Match by subject containing (upper or lower case, with or without spaces "Math 501"
-- or beging to or from prof@ethz.ch or prof@math.ethz.ch
msgs = recent:match_subject('\\b[Mm][Aa][Tt][Hh]\\W?501') +
       EECS.INBOX:contain_from('prof@(math.)?ethz.ch') +
       EECS.INBOX:contain_to('prof@(math.)?ethz.ch')
msgs:move_messages(EECS['math501'])
