;;; genderize-io.el --- genderize.io client library

;; Copyright (C) xxxx  -

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


;; Functions

(defun genderize-get-gender (name-or-names)
  (case (type-of name-or-names)
    ('string (shell-command-to-string
              (concat "curl -Ls \"http://api.genderize.io/?name="
                      name-or-names "\"")))
    ('cons (let ((query-string "?"))
             (dotimes (i (length name-or-names))
               (setq query-string (concat query-string "name\\\["
                                          (number-to-string i) "\\\]="
                                          (nth i name-or-names)
                                          (unless (eq i (1-
                                                         (length
                                                          name-or-names)))
                                            "&"))))
             (shell-command-to-string
              (concat "curl -Ls \"http://api.genderize.io/"
                      query-string "\""))))))


;; DEBUG
;;
;; Request with one name
;; (genderize-get-gender "pete")
;;
;; Request with multiple names
;; (genderize-get-gender (list "pete" "paul" "maria" "marie" "abc"))
;;
;; (let* ((s "[{\"name\":\"pete\",\"gender\":\"male\",\"probability\":\"1.00\",\"count\":55},{\"name\":\"paul\",\"gender\":\"male\",\"probability\":\"1.00\",\"count\":417},{\"name\":\"maria\",\"gender\":\"female\",\"probability\":\"1.00\",\"count\":700},{\"name\":\"marie\",\"gender\":\"female\",\"probability\":\"1.00\",\"count\":177},{\"name\":\"abc\",\"gender\":null}]")
;;        (ss (split-string (replace-regexp-in-string "^\\[\\|\\]$" "" s) "},")))
;;   (mapc (lambda (e) (insert (format "\n%s" e))) ss))


(provide 'genderize-io)
;;; genderize-io.el ends here
