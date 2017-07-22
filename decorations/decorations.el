(require 'cl)

;; 1. insert top/bottom edge
;; 2. insert left/right edge
;; (defun draw-square (w h)
;;   (interactive "nWidth: \nnHeight: ")
;;   (let ((colpos (current-column)))
;;     (loop for i from 0 below h do
;; 	    (loop for j from 0 below w do
;; 		  (insert (if (or (memq j (list 0 (1- w)))
;; 				  (memq i (list 0 (1- h))))
;; 			      "X"
;; 			    " ")))
;; 	    (insert "\n")
;; 	    (dotfimes (i colpos) (insert " ")))))


;; (defun largest-width-in-region (start end)
;;   (interactive "r")
;;   (save-excursion (goto-char start)
;; 		    (let ((column
;; 			   (loop while (< (point) end)
;; 				 maximize (- (point-at-eol) (point-at-bol))
;; 				 do (forward-line 1))))
;; 		      (message "Largest column is %s" column)
;; 		      column)))


;; (defun my-get-buffer-cols-max-width ()
;;   "Return maximum number of columns used in the current buffer."
;;   (interactive)
;;   (let ((count 0) (num-of-lines (count-lines (point-min) (point-max))))
;;     (save-excursion
;;       (goto-line 1)
;;       (while (< (line-number-at-pos) num-of-lines)
;;         ;; (setq count (max count (- (point-at-eol) (point-at-bol))))
;;         (goto-char (point-at-eol))
;;         (setq count (max count (current-column)))
;;         (forward-line))
;;         (1+ count))))

;; (defun largest-width-in-region (start end)
;;   "Return maximum number of columns used in the current buffer."
;;   (interactive "r")
;;   (let ((count 0) (num-of-lines (count-lines start end)))
;;     (save-excursion
;; 	(goto-line 1)
;; 	(while (< (line-number-at-pos) num-of-lines)
;; 	  ;; (setq count (max count (- (point-at-eol) (point-at-bol))))
;; 	  (goto-char (point-at-eol))
;; 	  (setq count (max count (current-column)))
;; 	  (forward-line))
;;       (1+ count))))


(defun largest-width-in-region (start end)
  "largest-width-in-region gets the maximum column width in a region."
  (interactive "r")
  (save-excursion (goto-char start)
		    (let ((column
			   (loop while (<= (point) end)
      			 ;;  				 maximize (- (point-at-eol) (point-at-bol))
      			 maximize (progn (goto-char (point-at-eol)) (current-column))
				 do (forward-line 1))))
      	      ;;  		      (message "Largest column is %s" column)
		      column)))


(defun largest-width-in-buffer (start end)
  "largest-width-in-buffer gets the maximum column width in the current buffer."
  (interactive "r")
  (save-excursion (goto-char start)
		    (let ((column
			   (loop while (< (point) end)
				 maximize (- (point-at-eol) (point-at-bol))
				 do (forward-line 1))))
		      (message "Largest column is %s" column)
		      column)))


(defun insert-top-and-bottom-edge (start end)
  "insert-top-and-bottom-edge inserts the top edge and the bottom edge for the frame."
  (interactive "r")
  (defvar x)
  (setq x (largest-width-in-region start end))
  (save-excursion
    ;; Draw the top edge
    (goto-char start)
    ;;		    (insert "\n")
    (loop for i from 0 below (+ x 2)
          do (insert "X"))
    (insert "\n"))
  ;; Draw the bottom edge
  (save-excursion
    (goto-char (point-at-eol))
    (insert "\n")
    (loop for i from 0 below (+ x 2)
          do (insert "X"))))
  ;;    (insert "\n")))


(defun insert-local-top-and-bottom-edge (start end)
  "insert-local-top-and-bottom-edge inserts the top edge and the bottom edge for the local frame."
  (interactive "r")
  (defvar width)
  (defvar difference)
  (setq widthStart (- (region-beginning) (save-excursion (goto-char (region-beginning)) (beginning-of-line) (point))))
  (setq widthEnd (- (region-end) (save-excursion (goto-char (region-end)) (beginning-of-line) (point))))
  (setq width (- widthEnd widthStart))
  (setq difference (- (region-beginning) (save-excursion (goto-char (region-beginning)) (beginning-of-line) (point))))
  (save-excursion
    ;; Draw the top edge
    (goto-char start) (beginning-of-line)
    (loop for i from 0 below (1+ difference) ;; +1 because of the left/right edges' spaces
          do (insert " ")) ;; "H"
    (loop for i from 0 upto width
          do (insert "X"))
    (insert "\n"))
  ;; Draw the bottom edge
  (save-excursion
    (goto-char (point-at-eol))
    (insert "\n")
    (loop for i from 0 below (1+ difference) ;; +1 because of the left/right edges' spaces
          do (insert " ")) ;; "H"
    (loop for i from 0 upto width
          do (insert "X"))))


;; count-lines-region
(defun insert-left-and-right-edge (start end)
  "insert-left-and-right-edge inserts the left edge and the right edge for the frame."
  (interactive "r")
  (save-excursion
    (setq st (region-beginning))
    (setq en (region-end))
    ;; insert left edge
    ;;      (string-insert-rectangle st en "S")
    (let ((i 0)) (forward-line 1) (goto-char st)
         (setq  width (largest-width-in-region st en))
         (dotimes (i (+ (count-lines st en) 2))  ;; + 2 because of the top/bottom edges
           (beginning-of-line) (goto-char (point-at-bol))
           (insert "S")
           (forward-line 1)))
    ;; insert fillers and right edge
    (let ((i 0) (j 0)) (goto-char st)
         (setq  width (largest-width-in-region st en))
         (dotimes (i (+ (count-lines st en) 2))  ;; + 2 because of the top/bottom edges
           (beginning-of-line) (goto-char (point-at-eol))
           (dotimes (j (- width (current-column)))
             (insert " ")) ;; "K"
           (insert "P") ;; "P"
           (forward-line 1)))))


(defun insert-local-right-edge ()
"Insert TEXT right to the current region."
(interactive)
(let* ((beg (region-beginning))
       (end (region-end))
       (delta (- (save-excursion (goto-char end) (current-column))
                 (save-excursion (goto-char beg) (current-column))))
       true-start true-end)
  (if (< delta 0)
      (setq true-end (- end delta)
            true-start beg)
    (setq true-end end
          true-start (+ beg delta)))
  (string-insert-rectangle true-start true-end " L ")))


;; (defun insert-local-left-edge ()
;; "Insert TEXT right to the current region."
;; (interactive)
;; (region-beginning)
;; (let* ((beg (region-beginning))
;;        (end (region-end))
;;        (delta (- (save-excursion (goto-char end) (current-column))
;;                  (save-excursion (goto-char beg) (current-column))))
;;        true-start true-end)
;;   (if (< delta 0)
;;       (setq true-end (- end delta)
;;             true-start beg)
;;     (setq true-end end
;;           true-start (+ beg delta)))
;;   (string-insert-rectangle true-start true-end "P")))



(defun insert-local-left-and-right-edge (start end)
  (interactive "r")
  (setq st start)
  (setq en end)
    (setq startColumn (save-excursion (goto-char (region-beginning)) (current-column)))
    (setq endColumn (save-excursion (goto-char (region-end)) (current-column)))
    (setq delta (- endColumn startColumn))
  (save-excursion
    (string-insert-rectangle st en " S ")
    (insert-local-right-edge)))


(defun insert-frame (start end)
  (interactive "r")
  (insert-top-and-bottom-edge start end)
  (insert-left-and-right-edge start end))


(defun insert-local-frame (start end)
  (interactive "r")
  (insert-local-left-and-right-edge start end)
  (insert-local-top-and-bottom-edge start end))
