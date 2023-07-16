lua << EOF
require('orgmode').setup_ts_grammar()
require('nvim-treesitter.configs').setup {
  highlight = {
    enable = true,
    disable = {'org'},
    additional_vim_regex_highlighting = {'org'},
  },
  ensure_installed = {'org'},
}
require('orgmode').setup({
  org_agenda_files = {'~/env/home/org/*'},
  org_default_notes_file = '~/env/home/org/refile.org',
  org_priority_highest = 1,
  org_priority_default = 5,
  org_priority_lowest = 5,
  org_capture_templates = {
    t = {
      description = 'Task',
      template = '* TODO %?\n  %u'
    },
    Q = {
      description = 'Question',
      template = '* TODO Question: %?\n  To: \n  Context: \n  %u',
      target = '~/env/home/org/questions.org',
    },
    r = {
      description = 'Request',
      template = '* TODO %?\n** Clarification\n\n** Why is this timeline required?\n** What is the problem that needs solved?\n  %u',
      target = '~/env/home/org/dremio.org',
    },
    p = {
      description = 'New performance test run',
      template = '* TODO %?\n** Clarification\n*** Which benchmark should I run?\n*** What is the target platform?\n*** What is the deadline?\n*** What is the motivation behind the request? What is the problem that needs solved?\n*** What is the exit criteria?\n** JIRA ticket: DX-?????\n** Keyword cycle reminder: TODO -> CLARIFYING -> IN_PROGRESS -> REPORTING -> ACKNOWLEDGING -> DONE\n',
      target = '~/env/home/org/dremio.org',
    },
    h = {
      description = 'New hire interview request',
      template = '* TODO Interview with %?\n** Clarification\n*** What is the role\'s mandate?\n*** What and who are the key relationships?\n*** What does success look like in 30 days, 90 days and 12 months?\n*** Who will be involved in the interview process and what will they be assessing?\n*** What are the top 3 most important attributes this role requires?\n',
      target = '~/env/home/org/dremio.org',
    },
  },
  org_todo_keywords = {'BLOCKED(b)', 'TODO(t)', 'ACKNOWLEDGING(k)', 'CLARIFYING(c)', 'DELEGATED(l)', 'IN_PROGRESS(i)', 'IN_REVIEW(r)', 'REPORTING(p)', '|', 'ABANDONED(a)', 'DONE(d)'},
  org_todo_keyword_faces = {
    -- Starting states
    BLOCKED = ':background #FF5555 :foreground #000000 :weight bold', -- Red
    TODO = ':foreground #FF5555 :weight bold', -- Red
    -- In progress steps
    ACKNOWLEDGING = ':foreground #BD93F9 :weight bold', -- Blue
    CLARIFYING = ':foreground #BD93F9 :weight bold', -- Blue
    DELEGATED = ':foreground #F1FA8C :weight bold', -- Yellow
    IN_PROGRESS = ':foreground #BD93F9 :weight bold', -- Blue
    IN_REVIEW = ':foreground #F1FA8C :weight bold', -- Yellow
    REPORTING = ':foreground #BD93F9 :weight bold', -- Blue
    -- Final steps
    ABANDONED = ':foreground #FFB86C :weight bold', -- Orange
    DONE = ':foreground #50FA7B :weight bold', -- Green
  },
})
EOF
