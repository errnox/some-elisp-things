;;; analysis.el --- CSV analysis

;; Copyright (C) xxxx

;; Author: - <xxx@xxx.xxx>
;; Keywords: data

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


;; Variables

(defvar an-data-file "data.csv")
(defvar an-row-separator "\n")
(defvar an-field-separator ",")
(defvar an-data (list))
(defvar an-sorted-data (list))


;; Functions

(defun an-get-rows (row-data row-separator)
  (split-string row-data row-separator t))

(defun an-init-analysis ()
  (with-temp-buffer
    (progn
      (insert-file-contents an-data-file)
      (kill-line 4)  ; Remove header cruft
      (mapc (lambda (row)
              (setq an-data (append an-data (list (split-string
                                                   row
                                                   an-field-separator
                                                   t)))))
            (an-get-rows (buffer-string) an-row-separator)))))

(defun an-sort-rows-by-nth-column-alphabetically (data n &optional
                                                       ignore-case reverse)
  (let ((ignore-case (or ignore-case t))
        (reverse (if reverse t nil)))
    (sort data (lambda (x y)
                 (let* ((xx (nth n x))
                        (yy (nth n y))
                        (o (compare-strings xx 0 (length xx)
                                            yy 0 (length yy)
                                            ignore-case)))
                   (if (not (eq o t))
                       (if (< o 0)
                           (not reverse)
                           reverse)
                       reverse))))))

(defun an-sort-rows-by-nth-column-string-lengthwise (data n &optional
                                                          reverse)
  (let ((reverse (if reverse reverse nil)))
    (sort data (lambda (x y)
                 (let ((x-length (length (nth n x)))
                       (y-length (length (nth n y))))
                   (if (> x-length y-length)
                       reverse
                       (not reverse)))))))

(defun an-sort-rows-by-nth-column-numerically (data n &optional
                                                    reverse)
  (let ((reverse (if reverse reverse nil)))
    (sort data (lambda (x y)
                 (if (> (string-to-number (nth n x)) (string-to-number
                                                      (nth n y)))
                     reverse
                     (not reverse))))))

(defun an-write-data-to-buffer (data buffer &optional &key column)
  (display-buffer (get-buffer-create buffer) t)
  (with-selected-window (get-buffer-window buffer)
    (erase-buffer)
    (mapc (lambda (row)
            (if column
                (insert (format "%s\n" (nth column row)))
                (insert (format "%s\n" (mapconcat 'identity row ",")))))
          data)))

;; DEBUG

;; Init
;;
;; (setq an-data (list))
;; (setq an-sorted-data (list))
;; (an-init-analysis)
;;
;; Test data has columns 0,1,2,3,4,5
;;
;; (setq an-sorted-data (an-sort-rows-by-nth-column-alphabetically an-data 5
;;                                                                 nil nil))
;; (an-write-data-to-buffer an-sorted-data "***Output")

(setq an-sorted-data (an-sort-rows-by-nth-column-string-lengthwise an-data
                                                                   5 nil))
(an-write-data-to-buffer an-sorted-data "***Output")

;; (let ((column 4))
;;   (setq an-sorted-data (an-sort-rows-by-nth-column-numerically
;;                         an-data column nil))
;;   (an-write-data-to-buffer an-sorted-data "***Output" :column column))


(provide 'analysis)
;;; analysis.el ends here
