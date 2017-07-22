;;; shapes.el --- Arbitrary-sized shape generator (triangle/circle/diamond)

;; Copyright (C) xxxx

;; Author: - <xxx@xxx.xxx>
;; Keywords: tools

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; ---

;;; Code:



;; (% 1 2)  ; 1 <-- odd
;; (% 2 2)  ; 0 <-- even

(defun triangle (lines &optional char evens)
  "Returns a triangle shape as string. CHAR can be used to set the
character used. If EVENS is true every line will contain an even number of
CHARs."
  (let* ((comparator (if (equal evens t)
                         1
                         0))
         (char (or char "*"))
         (lines (* lines 2))
         (counter (/ lines 2))
         (triangle ""))
    (insert "\n")
    (dotimes (i lines)
      (if (equal (% i 2) comparator) ; All odds
          (setq counter (- counter 1))
          (dotimes (j counter)
            (setq triangle (concat triangle " ")))
          (dotimes (j i)
            (setq triangle (concat triangle char)))
          (setq triangle (concat triangle "\n"))))
    triangle))

(defun diamond (lines &optional char evens)
  "Returns a diamond shape as string. CHAR can be used to set the
character used. If EVENS is true every line will contain an even number of
CHARs."
  (let ((triangle (triangle lines char evens)))
    (with-temp-buffer
      (insert triangle)
      (mark-whole-buffer)
      (reverse-region (point-min) (point-max))
      (insert triangle)
      (buffer-string))))


(defun putxy (x y char)
  ""
  (goto-char (point-min))
  (forward-line y)
  (forward-char x)
  (delete-region (point) (+ (point) (length char)))
  (insert char))


(defun filled-circle (center-x center-y radius char)
  (let ((radius radius)
        (half-row-width 0))
    (loop for x from (- radius) to radius
          do
          (setq height (sqrt (abs (* (- (* radius radius) x) x))))
          (loop for y from (- height) to height
                do
                (putxy (abs (floor (+ center-x x)))
                       (abs (floor (+ center-y y))) char)))))


;; Tests
;; =====
;;
;;
;; Circle
;; ------
;;
;; (filled-circle 10 20 5 "*")
;; (with-current-buffer
;;     (switch-to-buffer "*Buffer*")
;;   ;; (putxy 5 10 "x")
;;   ;; (putxy 6 10 "y")
;;   (filled-circle 5 10 10 "*")
;;   )
;;
;;
;; Triangle
;; --------
;; 
;; (insert (format "%s" (triangle 10)))
;; (insert (format "%s" (triangle 10 "+" t)))
;;
;;
;; Diamond
;; -------
;;
;; (insert (format "%s" (diamond 10)))
;; (insert (format "%s" (diamond 10 "+" t)))



(provide 'shapes)
;;; shapes.el ends here
