;;; script.el --- Test script

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

;; -

;;; Code:

(setq debug-on-error t)


(dotimes (i 10)
    (princ (format "%d Hello there!\n" i)))

(terpri)

(princ (format "Args: %S\n" argv))


(setq argv nil)
(kill-emacs 0)

;; (provide 'script)
;;; script.el ends here
