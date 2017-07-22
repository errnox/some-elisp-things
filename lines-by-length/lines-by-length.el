;; Sort lines by length

(defun lines-by-length (start end &rest reversed)
  "Sort lines in region by line length"
  (interactive "r")
      (insert
       (mapconcat 'identity (sort (split-string (buffer-substring start end) "\n")
				  '(lambda (a b) (< (length a) (length b)))) "\n")))

(provide 'lines-by-length)
