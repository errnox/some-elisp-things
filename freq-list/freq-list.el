;;; freq-list.el ---

;; Copyright (C) XXXX

;; Author: xxx <xxx@xxx.xxx>
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


(defvar frq-input-file "./data/input")


(defun frq-read-input (file-name)
  (with-temp-buffer
    (insert-file-contents file-name)
    (buffer-string)))

(defun frq-uniq-token-list-create (tokens)
  (let ((uniq-tokens (list)))
    (dolist (token tokens)
      (add-to-list 'uniq-tokens token))
    uniq-tokens))

(defun freq-list-create (&optional reverse-order sort-alphabetically)
  (let* ((tokens (sort (split-string (frq-read-input frq-input-file) "\\b")
                       'string-lessp))
         (uniq-tokens (frq-uniq-token-list-create tokens))
         (freq-list (list)))
    (with-temp-buffer
      (dolist (token uniq-tokens)
        (insert token))
      (dolist (token uniq-tokens)
        (add-to-list 'freq-list
                     (cons token (count-matches token (point-min)
                                                (point-max))))))
    ;; XXX
    (if (and (boundp sort-alphabetically) (eq sort-alphabetically t))
        (setq freq-list (sort freq-list
                              '(lambda (x y)
                                 (string-lessp (downcase (car x))
                                               (downcase (car y))))))
        (setq freq-list (sort freq-list
                              '(lambda (x y)
                                 (min (car x) (cdr y))))))
    (if (and (boundp reverse-order) (eq reverse-order nil))
        (setq freq-list (reverse freq-list)))
    freq-list))


;; Test
;; 
;; (message
;;  (dolist (freq (freq-list-create))
;;    (insert-here (format "%s: %s" (cdr freq) (car freq)))))

(provide 'freq-list)
;;; freq-list.el ends here
