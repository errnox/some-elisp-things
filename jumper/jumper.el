(defvar sections '(1 2 3 4))
(defvar jumper-last-command nil)

(defun jumper-jump (section)
  (interactive "nSection: ")
  (let ((screen-height (window-body-height))
	(screen-line-min (line-number-at-pos (window-start)))
	(screen-line-max (line-number-at-pos (window-end))))
    (let ((section-length (/ screen-height 4)))
      (if (eq section 1)
	  (goto-line screen-line-min)
	(goto-line (+ (+ screen-line-min (* (- section 1) section-length)) 1))))))

(defun jumper-next-section ()
  (interactive "")
  (let ((head (pop sections)))
    (setq sections (append sections (list head)))
    (if (eq jumper-last-command 'jumper-previous-section)
	(progn
	  (setq head (pop sections))
	  (setq sections (append sections (list head)))))
    (jumper-jump head)
    (setq jumper-last-command this-command)))

(defun jumper-previous-section ()
  (interactive "")
  (let ((tail (car (last sections))))
    (setq sections (append (list tail) (butlast sections)))
    (if (eq jumper-last-command 'jumper-next-section)
	(progn
	  (setq tail (car (last sections)))
	  (setq sections (append (list tail) (butlast sections)))))
    (jumper-jump tail)
    (setq jumper-last-command this-command)))

(global-set-key (kbd "C-c C-v") 'jumper-jump)
(global-set-key (kbd "M-N") 'jumper-next-section)
(global-set-key (kbd "M-P") 'jumper-previous-section)

;;;###autoload
;; (define-minor-mode jumper-mode)

(provide 'jumper)
