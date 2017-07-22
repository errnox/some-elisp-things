(defun my-breadcrumb (path)
  "Return path in a breadcrumb format."
  (mapconcat 'identity
             (split-string path (char-to-string directory-sep-char) t)
             " > "))

(setq frame-title-format
      '(buffer-file-name
        (:eval (my-breadcrumb buffer-file-name))
        (dired-directory
         (:eval (my-breadcrumb dired-directory))
         ("%b"))))
