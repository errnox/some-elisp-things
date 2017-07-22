(defun insert-button (name command)
  (interactive "sName: \nsCommand: ")
  (let* ((cmd command)
         (cmd-action (lambda (x) (shell-command cmd))))
    (insert-button
     name 'action cmd-action 'follow-link t)))
