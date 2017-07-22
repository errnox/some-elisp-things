;;; dir-traverser.el --- Traverses directories

;; Copyright (C) XXXX

;; Author: - <xxx@xxx.xxx>
;; Keywords: files

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

;; This traverses directories... and is really ugly!

;;; Code:

;; Customizable variables

(defcustom trav-buffer "*Dir Test*"
  "Output buffer.")

(defcustom trav-indentation-prefix "  "
  "Prefix to sue when indenting lines.")

(defcustom trav-file-prefix ""
  "Prefix for file names.")

(defcustom trav-dir-prefix ""
  "Prefix for dir names.")


;; Functionos

(defun trav-traverse-dir (dir &optional no-dotfiles sort-predicate)
  "Traverse directory DIR and return a nested hash table with directory and
file names as keys and either another hash table as value for directories
or the string \"FILE\" as value for files

DIR - String path of the directory to create a hash table for.
NO-DOTFILES - Indicates if dotfiles should be included or left out. If `t',
              dotfiles will be excluded. For any other value dotfiles will
              be included.
SORT-PREDICATE - Sor predicate which is called for the directory DIR and
                 all its subdirectories. It is called with the full path
                 names for the current file or directory and the full path
                 name for the next file or directory. Thus, it may be
                 necessary to call `file-name-nondirectory' or similar
                 methods on each file/directory name.

Returns a nested hash tables with file or directory names as keys and with
either nested hash tables (for directories) or the string \"FILE\" (for
files) as values."
  (interactive "D")
  (let ((dir-tree (make-hash-table))
        (current-dir (make-hash-table))
        (thing-to-put nil)
        (sort-predicate (or sort-predicate nil)))
    (if (file-directory-p dir)
        (mapc (lambda (dir-or-file)
                (if (and (file-directory-p dir-or-file))
                    (setq thing-to-put (trav-traverse-dir dir-or-file
                                                          (or no-dotfiles
                                                              nil)
                                                          (or
                                                           sort-predicate
                                                           nil)))
                    (setq thing-to-put "FILE"))
                ;; For RegEx matching one could also use the MATCH argument
                ;; for `directory-files', but this solution gives
                ;; flexibility for alternative file/dir
                ;; ex-/inclusions/sorting etc.
                (if (not (and (eq no-dotfiles t)
                              (not (eq (string-match-p
                                        "^\\.\\w.*$"
                                        (file-name-nondirectory
                                         dir-or-file)) nil))))
                    (puthash dir-or-file thing-to-put dir-tree)))
              (if sort-predicate
                  (sort (directory-files dir t "[^.]+") sort-predicate)
                  (directory-files dir t "[^.]+"))))
    dir-tree))

(defun trav-pretty-print-hash-table (table &optional output-string
                                           indentation-level
                                           file-or-dir-name-only)
  "Pretty print the nested hash table TABLE created by `trav-traverse-dir'.

OUTPUT-STRING - The string to append the pretty printed version to. It is
                handed to every recursive call of this function.
INDENTATION-LEVEL - Integer representing the indentation level for the
                    current element. It is handed to every recursive call
                    of this function.
FILE-OR-DIR-NAME-ONLY - If `t', the file or directory name for each file or
                        directory is printed without its according
                        directory. Any other value will cause the full path
                        to be printed.

Returns a pretty-printed string representation of the hash-table TABLE."
  (maphash (lambda (key value)
             ;; Creating a new variable each time should not be a problem
             ;; in reality since the tree cannot be used for massive file
             ;; system hierarchies anyway.
             (defvar blanks "")
             (setq blanks "")
             (dotimes (i indentation-level)
               (setq blanks (format "%s%s" blanks
                                    trav-indentation-prefix)))
             (if (hash-table-p value)
                 (progn

                   (setq output-string
                         (trav-pretty-print-hash-table
                          value (format "%s\n%s%s%s" output-string blanks
                                        trav-dir-prefix
                                        (if file-or-dir-name-only
                                            (file-name-nondirectory key)
                                            key))
                          (1+ indentation-level)
                          (or file-or-dir-name-only nil))))
                 (setq output-string
                       (format "%s\n%s%s%s" output-string blanks
                               trav-file-prefix
                               (if file-or-dir-name-only
                                   (file-name-nondirectory key)
                                   key)))))
           table)
  output-string)


;; DEBUG
;;
;; (defun trav-write-to-other-window (text)
;;   (let* ((output-buffer (get-buffer-create trav-buffer)))
;;     (display-buffer-use-some-window output-buffer ())
;;     (with-selected-window (get-buffer-window output-buffer)
;;       (erase-buffer)
;;       (insert text)
;;       (beginning-of-buffer))))
;; 
;; (defun trav-write-to-other-window-go-there (text)
;;   (progn
;;     (switch-to-buffer-other-window (get-buffer-create trav-buffer))
;;     (erase-buffer)
;;     (insert text)
;;     (beginning-of-buffer)))
;; 
;; (trav-write-to-other-window
;;  (format "%s" (trav-pretty-print-hash-table
;;                (trav-traverse-dir
;;                 "~/temp/dirStruct/" t
;;                 (lambda (a b) (< (length (file-name-nondirectory a))
;;                                  (length (file-name-nondirectory b))))) ""
;;                                  0 t)))
;;
;; (trav-write-to-other-window-go-there
;;  (format "%s" (trav-pretty-print-hash-table (trav-traverse-dir
;;                                         "~/temp/dirStruct/") "" 0)))
;;
;; (trav-write-to-other-window-go-there
;;  (shell-command-to-string (concat "echo " (format "\'\n%s\'"
;;                                                   (json-encode
;;                                                    (trav-traverse-dir
;;                                                     "~/temp/dirStruct/")))
;;                                   " | python -m json.tool")))

(provide 'dir-traverser)
;;; dir-traverser.el ends here
