(add-to-invisibility-spec :invisible)
(remove-from-invisibility-spec :hidden)
(remove-from-invisibility-spec t)

(setq buffer-invisibility-spec (list :invisible :hidden))

(defun make-line-invisible ()
  (beginning-of-line)
  (set-mark (point))
  (end-of-line)
  (next-line)
  (beginning-of-line)
  (kill-region (mark) (point))
  (insert (propertize (car kill-ring) 'invisible t)))

(defun foo-explore ()
  (line-move 1)
  (beginning-of-line)
  (set-mark (point))
  (end-of-line)
  (kill-region (mark) (point))
  (line-move 2)
  (insert (propertize (car kill-ring) 'invisible :foo)))

(save-excursion
  (insert (format "\nfoo%s\nbar" (propertize "\nbaz" 'invisible t))))

(file-name-directory (directory-file-name "/this/is/a/path/"))

(atom "foo")
(atom :foo)

(setq selective-display nil)

(setq line-move-ignore-invisible nil)
(setq line-move-visual nil)
(save-excursion
  (insert (format "\nfoo%s\nbar%s\noof"
		  (propertize "\nbaz" 'invisible '(list :invisible
							:invisible))
		  (propertize "\nzab" 'invisible '(list :foo)))))

(let ((invisibility-marker :invisible))
  (insert (format "%S" invisibility-marker)))

(let ((l (list "foo" "bar")))
  (add-to-list 'l "baz"))


(let ((l (list "foo" "bar" "baz")))
  (pop l)
  l)

(let ((l (list :init))
      (invisibility-marker :invisible))
  (setq l (append (list invisibility-marker) l))
  (pop l)
  (setq l (append (list invisibility-marker) l))
  (setq l (append (list invisibility-marker) l))
  (setq l (append (list invisibility-marker) l))
  (setq l (append (list invisibility-marker) l))
  l)
