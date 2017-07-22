(defun print-region-start-and-end (myStart myEnd)
  "Prints region start and end positions"
  (interactive "r")
  (message "Region begin at: %d, end at: %d" myStart myEnd)
  )

(defun insert-p-tag ()
  "Insert <p></p> at cursor point."
  (interactive)
  (insert "<p></p>")
  (backward-char 4))

(defun wrap-markup ()
  "Insert a markup <b></b> around a region."
  (interactive)
  (save-excursion
    (goto-char (region-end)) (insert "</b>")
    (goto-char (region-beginning)) (insert "<b>")
    ))

(defun select-current-word ()
  "Select the word under cursor.
\"word\" here is considered any alphanumeric sequence with \"_\" or \"-\"."
  (interactive)
  (let (pt)
    (skip-chars-backward "-_A-Za-z0-9")
    (setq pt (point))
    (skip-chars-forward "-_A-Za-z0-9")
    (set-mark pt)
    ))

(defun select-current-line ()
  "Select the current line"
  (interactive)
  (end-of-line) ; move to end of line
  (set-mark (line-beginning-position)))

(defun replace-html-chars-region (start end)
  "Replace \"<\" to \"&lt;\" and other chars in HTML.
This works on the current region."
  (interactive "r")
  (save-restriction
    (narrow-to-region start end)
    (goto-char (point-min))
    (while (search-forward "&" nil t) (replace-match "&amp;" nil t))
    (goto-char (point-min))
    (while (search-forward "<" nil t) (replace-match "&lt;" nil t))
    (goto-char (point-min))
    (while (search-forward ">" nil t) (replace-match "&gt;" nil t))
    )
  )

(defun delete-enclosed-text ()
  "Delete texts between any pair of delimiters."
  (interactive)
  (save-excursion
    (let (p1 p2)
      (skip-chars-backward "^(<[\"") (setq p1 (point))
      (skip-chars-forward "^)>]\"") (setq p2 (point))
      (delete-region p1 p2))))

(defun next-user-buffer ()
  "Switch to the next user buffer in cyclic order.\n
User buffers are those not starting with *."
  (interactive)
  (next-buffer)
  (let ((i 0))
    (while (and (string-match "^*" (buffer-name)) (< i 50))
      (setq i (1+ i)) (next-buffer) )))

(global-set-key (kbd "C-<next>") 'next-user-buffer) ; Ctrl+PageUp


(defun previous-user-buffer ()
  "Switch to the previous user buffer in cyclic order.\n
User buffers are those not starting with *."
  (interactive)
  (previous-buffer)
  (let ((i 0))
    (while (and (string-match "^*" (buffer-name)) (< i 50))
      (setq i (1+ i)) (previous-buffer) )))

(global-set-key (kbd "C-<prior>") 'previous-user-buffer) ; Ctrl+PageDown

(random t) ; seed it randomly


(defun insert-random-number ()
  "Insert a random number between 0 to 999999."
  (interactive)
  (insert (number-to-string (random 999999))) )

(defalias 'irn 'insert-random-number)

(defun insert-random-hexinumber ()
  "Insert a random 4-digit hexidecimal number, with 0 padded in front."
  (interactive)
  (insert
   (format "0%4x" (random 65535)) ) )


(defun word-definition-lookup ()
  "Look up the word under cursor in a browser."
  (interactive)
  (browse-url
   (concat "http://www.answers.com/main/ntquery?s="
           (thing-at-point 'symbol)))
  )

(defun insert-column-counter (n)
  "Insert a sequence of integers vertically.
For example, if your text is:

a b
c d
e f

and your cursor is after \"a\", then calling this function with argument
3 will change it to become:

a1 b
c2 d
e3 f

If there are not enough existing lines after the cursor
when this function is called, it aborts at the last line.

This command is conveniently used together with `kill-rectangle' and `string-rectangle'."
  (interactive "nEnter the max integer: ")

  (let ((i 1) colpos line-move-visual-original)
    (setq line-move-visual-original line-move-visual)
    (setq line-move-visual nil)
    (setq colpos (- (point) (point-at-bol)))
    (while (<= i n)
      (insert (number-to-string i))
      (forward-line) (beginning-of-line) (forward-char colpos)
      (setq i (1+ i))
      )
    (setq line-move-visual line-move-visual-original)
    ))

(defun draw-square (n)
  "Draws a square."
  (interactive "nWidth/height: ")
  (let ((i 1) (j 1) colpos)
    (setq colpos(- (point) (point-at-bol)))
    (while (<= i n)
      (setq i (1+ n))
      (insert "X")
      (forward-char colpos)
      )
    (while (<= j n)
      (setq j (1+ j))
      (insert "X")
      (while (<= (- j 1) n)
        (insert "x")
        )
      )
    (insert "X")
    (forward-line) (beginning-of-line) (forward-char colpos)))
