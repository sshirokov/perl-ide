(require 'cl)

(setq perl-repl-buffer "perl-repl")
(setq perl-repl-bin "re.pl")

(defun perl-repl-buffer-name ()
  (format "*%s*" perl-repl-buffer))

(defun perl-make-repl-buffer (&optional switch)
  (make-comint perl-repl-buffer perl-repl-bin)
  (and switch (switch-to-buffer (perl-repl-buffer-name)))
  (perl-repl-buffer-name))

(defun run-perl (prefix)
  (interactive "P")
  (let ((buffer (or (get-buffer (perl-repl-buffer-name))
                    (perl-make-repl-buffer))))
    (cond (prefix (switch-to-buffer buffer))
          (t (switch-to-buffer-other-window buffer)))
    buffer))

(defun perl-eval-region (start end)
  (interactive "r")
  (perl-eval-string (buffer-substring start end)))

(defun perl-eval-string (str)
  (or (get-buffer (perl-repl-buffer-name))
      (perl-make-repl-buffer nil))
  (comint-send-string (get-buffer-process (perl-repl-buffer-name)) (concat str "\n")))

(defun perl-eval-buffer ()
  (interactive)
  (perl-eval-string (buffer-string)))


(defun perl-switch-to-repl (&optional prefix)
  (interactive "P")
  (select-window (or (get-buffer-window (perl-repl-buffer-name))
                     (cond (prefix
                            (get-buffer-window (switch-to-buffer (perl-repl-buffer-name))))
                           (t
                            (get-buffer-window (switch-to-buffer-other-window (perl-repl-buffer-name))))))))



(add-hook 'perl-mode-hook '(lambda ()
                             (local-set-key [(control c) (control c)] 'perl-eval-buffer)
                             (local-set-key [(control c) (control z)] 'perl-switch-to-repl)))

(provide 'perl-ide)
