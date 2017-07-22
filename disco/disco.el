;; Fallback color
;; (set-cursor-color "#839496")

;; Interesting color combination for blinking
;; (set-cursor-color "#00ee33")  ; green
;; (set-cursor-color "#ee3300")  ; red


;; DEBUG
(defun ddprint (message)
  (with-output-to-temp-buffer "*Output*"
    (prin1 message)
    (switch-to-buffer "*Output*")))

;; DEBUG
(defun dprint (message)
  (let ((debug-buffer "*Output*"))
    (display-buffer (get-buffer-create debug-buffer))
    (with-selected-window (get-buffer-window debug-buffer t)
      (turn-on-font-lock)
      (end-of-buffer)
      (insert (format "\n%s" message)))))

(defun generate-colors (&optional amount)
  (defvar colors)
  (setq colors (list))
  (let* ((max (expt 2 24))
         (amt (or amount max))
         (steps (or (/ max amt) 1)))
    (loop
     for i from 0 to max by steps
     do (push (format "#%06x" i) colors)))
  colors)

(progn
  (setq colors '())
  (let* ((colors (generate-colors 10))
         (lengths (mapcar (lambda (color) (length (format "%s" color)))
                          colors)))
    (dprint (format "MIN-LENGTH: %s\nMAX-LENGTH: %s\nSUM: %s\n%s"
                    (apply 'min lengths) (apply 'max lengths)
                    (length colors) colors))))








(defun color-test (&optional num-colors)
  (let ((num-colors (or num-colors nil))
	(colors (list)))
    (setq colors (mapcar '(lambda (color) (propertize color 'font-lock-face
                                                      (list :foreground color)))
                         (generate-colors num-colors)))
    colors))


(dolist (color (color-test 255))
  (dprint color))








;; (defun minimal-blink ()
;;   "Makes the cursor blink"
;;   (set-cursor-color "#00ee33")
;;   (sit-for 0.1)
;;   (set-cursor-color "#ee3300"))

;; (progn
;;   (defvar colors '())
;;   (setq colors '())
;;   (setq colors (generate-colors 9999)))
;; (defun blink ()
;;   "Makes the cursor blink"
;;   (dolist (color colors)
;;     (set-cursor-color color)
;;     (sit-for 0.1)))

;; (blink)

;; ;; TODO: Clever timer object management
;; ;;
;; ;; `run-with-timer' returns a timer object which is added to `timer-list'
;; ;; This can be cancelled using `cancel-timer'
;; (defvar blink-timer (run-with-timer 0.5 1.0 'blink))
;; (cancel-timer blink-timer)
