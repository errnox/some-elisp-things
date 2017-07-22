(defvar is-split nil
  "Indicates if the current window is already split or if it is not
split yet. `t': it is split; `nil': it is not split yet")

(defvar temp-region-copy
  "Stores away the region to be able to restore it later.")

(defface note-face
  '((((class color) (background light)) (:foreground "red" :background "blue"))
    (((class color) (background dark)) (:foreground "white" :background "blue")))
  "Face for a note."
  :group 'notize)

(defface region
  '((((class color) (min-colors 88) (background dark))
     :background "blue3")
    (((class color) (min-colors 88) (background light))
     :background "lightgoldenrod2")
    (((class color) (min-colors 16) (background dark))
     :background "blue3")
    (((class color) (min-colors 16) (background light))
     :background "lightgoldenrod2")
    (((class color) (min-colors 8))
     :background "blue" :foreground "white")
    (((type tty) (class mono))
     :inverse-video t)
    (t :background "gray"))
  "Basic face for highlighting the region."
  :group 'basic-faces)


(defun splitty ()
  (if (and (eq (point) 2) (eq is-split nil))
	(progn (setq is-split t)
		 	(message "one t")
		 	(split-window-horizontally))
		 	(cancel-timer 'timer-one)
    (progn (setq is-split t)
	     (delete-other-windows))))


(defun point-at-north (target-point)
  "Return point north of current point."
  (save-excursion (goto-char target-point)
      	    (previous-line)
      	    (point)))

(defun point-at-south (target-point)
  "Return point south of current point."
  (save-excursion (goto-char target-point)
      	    (next-line)
      	    (point)))

(defun point-at-west (target-point)
  "Return point west of current point."
  (save-excursion (goto-char target-point)
      	    (backward-char)
      	    (point)))

(defun point-at-east (target-point)
  "Return point east of current point."
  (save-excursion (goto-char target-point)
      	    (forward-char)
      	    (point)))

(defun point-at-northeast (target-point)
  "Return point northeast of current point."
  (save-excursion (goto-char target-point)
      	    (previous-line)
      	    (forward-char)
      	    (point)))

(defun point-at-southeast (target-point)
  "Return point southeast of current point."
  (save-excursion (goto-char target-point)
      	    (next-line)
      	    (forward-char)
      	    (point)))

(defun point-at-southwest (target-point)
  "Return point southwest of current point."
  (save-excursion (goto-char target-point)
      	    (next-line)
      	    (backward-char)
      	    (point)))

(defun point-at-northwest (target-point)
  "Return point northwest of current point."
  (save-excursion (goto-char target-point)
      	    (previous-line)
      	    (backward-char)
      	    (point)))


(defun point-around-target-point (target-point)
  (or (eq target-point (point-at-north))
	    (eq target-point (point-at-northeast))
	    (eq target-point (point-at-east))
	    (eq target-point (point-at-southeast))
	    (eq target-point (point-at-south))
	    (eq target-point (point-at-southwest))
	    (eq target-point (point-at-west))
	    (eq target-point (point-at-northwest))))

(defun is-neighbour-of-target-point (target)
  "Returns t if point is one of the neighbours of target.
Else it returns nil."
  (or (eq (point) (point-at-north target))
      (eq (point) (point-at-northeast target))
      (eq (point) (point-at-east target))
      (eq (point) (point-at-southeast target))
      (eq (point) (point-at-south target))
      (eq (point) (point-at-southwest target))
      (eq (point) (point-at-west target))
      (eq (point) (point-at-northwest target))))


(defun splitty ()
  (if (eq is-split t)
	(progn (setq is-split nil)
	       (split-window-horizontally)) )
  (if (eq (point) 122)
	(progn (setq is-split t)
             (message "t"))
    (progn (setq is-split nil) )))

;; Maybe...
;;
;; (defun splittyz ()
;;   (if (and (eq is-split nil) (eq (point) 2))
;; 	(progn (setq is-split t)
;; 	       (split-window-horizontally))
;;     (progn (setq is-split nil)
;; 	     (delete-other-windows)))))
;; (if (eq (point) 2)
;; 	(progn (setq is-split t))
;;   (progn (setq is-split nil))))


(defun report ()
  (if (is-neighbour-of-target-point 122)
      (message "In the comfort zone!")
    (message "Idle.")))

(add-hook 'post-command-hook
          'report)


(defun insert-ov (ov-text)
  "Inserts text with a specific overlay."
  (interactive "sText to insert: ")
  (save-excursion (insert ov-text))
  (let ((ov (make-overlay (point) (+ (point) (length ov-text))
      		    (current-buffer) t)))
    (overlay-put ov 'face 'note-face)))

(define-key ctl-x-map "\C-p" 'insert-ov)

(defun add-note (ov-start ov-end)
  "Adds a note for the current region."
  (interactive "r")
  (setq temp-region-copy (buffer-substring (region-beginning)
      				     (region-end)))
  (let ((ov (make-overlay ov-start ov-end)))
    (overlay-put ov 'face 'note-face)))

(defun remove-note (ov-start ov-end)
  "Removes the note in the current region."
  (interactive "r")
  (delete-region (region-beginning) (region-end))
  (insert temp-region-copy))
