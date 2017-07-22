(defun comment-string-with-major-mode-on (string major-mode)
  "Treats STRING as if it was in a buffer with MAJOR-MODE on, then comments
it using the correct comment style and returns it."
  (progn
    (setq string
          (with-temp-buffer
            (insert string) major-mode
	    (comment-region (point-min) (point-max))
	    (buffer-string)))))

;; Examples:
;
;; 1.
;;
;;   (comment-string-with-major-mode-on "This\nis\na\list" (eval 'major-mode))
;;
;; 2.
;;
;;   (comment-string-with-major-mode-on "This\nis\na\list" 'html-mode)
