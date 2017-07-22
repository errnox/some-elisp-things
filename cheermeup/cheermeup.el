(defvar cheer-me-up-buffer "CheerUp")

(defun cheer-me-up (force)
  "Cheers you up. For sure."
  (interactive "r")
  (cond ((equal force "hard") (cheer-me-up-hard))
  	((equal force "human") (cheer-me-up-human))
  	((equal force "gentle") (cheer-me-up-gentle))))

(defun cheer-me-up-hard ()
  "Makes you sparkle"
  (show-message "HARD"))

(defun cheer-me-up-human ()
  "Makes you smile, at least."
  (show-message "HUMAN"))

(defun cheer-me-up-gentle ()
  "You wuss!"
  (show-message "GENTLE"))

(defun show-message (message)
  (save-excursion
    (switch-to-buffer-other-window cheer-me-up-buffer)
    (insert message)))
