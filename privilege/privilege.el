;;; privilege.el --- Checks your privilege

;; Copyright (C) xxxx

;; Author: - <xxx@xxx.xxx>
;; Keywords: games, convenience

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


;; TODO - Use these as reference:
;; http://i2.kym-cdn.com/photos/images/original/000/423/405/bb2.png
;; http://knowyourmeme.com/memes/check-your-privilege

(defvar influencers (list)
  "Contains all influencial factors (`influencers') for a privilege.")

(defvar privilege 0
  "Contains the value for the privilege")

(defun dispatch-influencer (influencer privilege)
  "Dispatches an `influencer' and recalculates `privilege' depending on its
additivity and degree of influence.

An influencer has to have this structure:

  (\"Desscription\" 'influence-function 'influence-value)

where `influence-function' is the type of influence represented as one of
these functions:
- `+'
- `-'
- `*'
- `/'

`privilege' is a numeric value.)"
  (setq privilege (funcall (nth 1 influencer) privilege
                           (nth 2 influencer))))


(defun calculate-privilege (influencers)
  "Calculates the privilege based on `influencers'.
For the required `influencers' structure see `dispatche-influencer'."
  (let ((privilege 0))
    (mapc (lambda (influencer) (progn
                                 (setq privilege (dispatch-influencer
                                                  influencer privilege))))
          influencers)
    privilege))


;; Test
;;
;; (setq influencers (list
;;   (list "Foo" '+ 30)
;;   (list "Bar" '- 10)
;;   (list "Baz" '+ 43)
;;   (list "Zab" '+ 40)))
;; 
;; (with-current-buffer "*Test*"
;;   (mark-whole-buffer)
;;   (kill-region (region-beginning) (region-end))
;;   ;; (keyboard-quit)
;;   (insert (format "ime: %s\n--------\n\n" (current-time)))
;;   (insert (format "%s\n" (calculate-privilege influencers))))


(provide 'privilege)
;;; privilege.el ends here
