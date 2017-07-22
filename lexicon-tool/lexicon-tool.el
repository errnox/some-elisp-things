(require 'popup)
(require 'cl)



;; Header line example (anything)
;;
;; (defface anything-header
;;   '((t (:inherit header-line)))
;;   "Face for header lines in the anything buffer." :group 'anything)



;; Helper
(defun get-word-under-cursor ()
  (interactive)
  (minibuffer-message (thing-at-point 'word)))

;; Open a file, process it, save it, close it
(defun my-process-file (fPath)
  "Process the file at FPATH"
  (let (myBuffer)
    (setq myBuffer (find-file fPath))
    (widen) (goto-char (point-min)) ;; In case buffer is already open
    ;; Do something
    (save-buffer)
    (kill-buffer myBuffer)))

;; Temp buffer
(defun my-process-file (fPath)
  "Process the file at path FPATH"
  (let ()
    ;; Create temp buffer, process, when done, then write to fPath
    (with-temp-file fPath
      (insert-file-contents fPath)
      ;; Process it
      )))

;; Read a whole file into a list of lines
(defun read-lines (filePath)
  "Returns a list of lines of a file at FILEPATH."
  (with-temp-buffer
    (insert-file-contents filePath)
    (split-string (buffer-string) "\n" t)))

(defun create-overview-buffer ()
  (let (inputList, input, lineList)
    (setq inputList (read-lines "./data.txt"))
    (switch-to-buffer (generate-new-buffer "*Overview*"))
    (loop for i in inputList
	  do
	  (insert "| ")
	  (loop for j in (split-string i "\\\\" t)
		   do (insert (concat j " | ")))
	  (insert " |\n"))
    (org-table-align)
    (org-mode)
    (add-head-line)))

(defface custom-header-face
  '((t (:inherit header-face :background "yellow")))
  "Face for header lines in the anything buffer.")

(defun add-head-line ()
  (setq header-line-format t)
  (setq header-line-format `(
     ,(propertize "Type " 'face 'compilation-warning)
     " Freq "
     ,(propertize " Disp " 'face 'compilation-warning)
     " FreqW "
     ,(propertize " DispW " 'face 'compilation-warning)
     " FreqS "
     ,(propertize " DispS " 'face 'compilation-warning))))


(create-overview-buffer)
