;;; printer.el --- Prints things

;; Copyright (C) xxxx

;; Author: xxxx <xxx@xxx.xxx>
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


(defun insert-here (message)
  "Insert MESSAGE in the next line while preserving the current cursor
position; even if there are trailing functions/parameters/parenthesises/...

Example usage:
Go to any arbitrary function/variable/..., wrap it with an `insert-here'
sexp and run `eval-last-sexp' (C-x C-e) and instantly see the output in the
next line"
  (save-excursion
    (end-of-line 1)
    (insert (format "\n%s" message))))



(provide 'printer)
;;; printer.el ends here
