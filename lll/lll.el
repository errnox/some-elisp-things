(require 'button)

(defun insert-line-below ()
  "Insert a line below current line and move cursor to the beginning of this
    line"
  (interactive)
  (move-end-of-line nil)
  (newline))

(defun insert-line-above ()
  "Insert a line above current line and move cursor to the beginning of this
    line"
  (interactive)
  (move-beginning-of-line nil)
  (newline)
  (previous-line))

(defun query-description-pair (queries)
  "Query for description/URL pairs and insert them at the bottom of the current
   buffer."
  (interactive "p")
  (loop
    (let ((description (read-from-minibuffer "Description: "))
          (url (read-from-minibuffer "URL: ")))
      (unless (or (equal description "") (equal url ""))
        (end-of-buffer)
	(let ((old-mode major-mode))
	(org-mode)
	(org-insert-heading 3)
	(insert  (format "%s\n%s" description url))
	(funcall old-mode)))
      (insert "\n"))))

(defun write-to-buffer (name)
  "Creates a new buffer or chooses an existing buffer matching NAME, queries for
  description/url pairs and inserts them in this buffer."
  (with-current-buffer (pop-to-buffer (get-buffer-create name))
    (org-mode)
    (switch-to-buffer name)
    (query-description-pair 3)))

;; -----------------------------------------------------------------------------

(defvar testbuffer-name "ShowBufferTest")
(defvar menu
  '(("blue" . "#0000FF")
    ("green" . "#00FF00")
    ("red" . "#FF0000")
    ("white" . "#FFFFFF")
    ("black" . "#000000")))

(type-of menu)

(defun create-a-buffer (x y)
  (with-current-buffer (pop-to-buffer
   (get-buffer-create testbuffer-name))))

(defun kill-a-buffer (x y)
  (kill-buffer testbuffer-name))

(defun write-button-to-buffer (name)
  "Creates a new buffer or chooses an existing buffer matching NAME, queries for
  description/url pairs and inserts them in this buffer."
  (with-current-buffer (pop-to-buffer (get-buffer-create name))
    (org-mode)
    (switch-to-buffer name)
    (insert "\n        ")

    (let ((button-text "button"))
      (add-text-properties 0 (length button-text)
			   '(tag "Test Tag"
				 point-entered create-a-buffer
				 point-left kill-a-buffer)
			   button-text)
    (insert-button button-text
		   'action (lambda (x) (message "Text inserted."))
		   'point-entered (lambda (x) (message "Button entered."))
		   'point-left (lambda (x) (message "Button left.")))
    (insert "fooo\n")
    (setq buffer-read-only t))))

(write-button-to-buffer "buttonTest")



;; Tests
;;
;; (insert-line-below)
;; (insert-line-above)
;; (query-description-pair 3)
;;
;; (dotimes (i 5 i)
;;   (message (number-to-string i)) (sleep-for 0.5)
;;   )
;;
;; Switch to org-mode, run org-mode functions and then switch back to the
;; previous mode.
;; (save-excursion
;;   (let ((old-mode major-mode))
;;     (org-mode)
;;     (org-insert-heading 3)
;;     (funcall old-mode)))
;;
;; (write-to-buffer "testBuffer")
;;
;; (progn
;;   (let ((name "test"))
;; 	     (generate-new-buffer name)
;; 	     (switch-to-buffer name)))
;;
;; (set-text-properties 2 10 '(face '(bold underline (:foreground "red"))))
