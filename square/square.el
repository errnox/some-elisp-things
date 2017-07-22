(defun draw-square (w h)
  (interactive "nWidth: \nnHeight: ")
  (let ((colpos (current-column)))
    (loop for i from 0 below h do
          (loop for j from 0 below w do
      	  (insert (if (or (memq j (list 0 (1- w)))
      			  (memq i (list 0 (1- h))))
      		      "X"
      		    " ")))
          (insert "\n")
          (dotimes (i colpos) (insert " ")))))
