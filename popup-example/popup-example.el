(require 'popup)

(defun where-am-i ()
  (where-am-i)

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
  "Process teh file at path FPATH"
  (let ()
    ;; Create temp buffer, process, when done, then write to fPath
    (with-temp-file fPath
      (insert-file-contents fPath)
      ;; Process it
      )))

;; Read a whole file into a list of lines
(defun read-lines (fPath)
  "Return a list of lines of afile at FPATH"
  (with-temp-buffer
    (insert-file-contents fPath)
    (split-string (buffer-string) "\n" t)))
