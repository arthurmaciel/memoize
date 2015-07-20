;;
;; Memoize - egg to memoize procedures
;;
;; Copyright (c) 2015, Arthur Maciel
;; All rights reserved.
;;
;; Redistribution and use in source and binary forms, with or without
;; modification, are permitted provided that the following conditions
;; are met:
;;
;; 1. Redistributions of source code must retain the above copyright
;;    notice, this list of conditions and the following disclaimer.
;; 2. Redistributions in binary form must reproduce the above copyright
;;    notice, this list of conditions and the following disclaimer in the
;;    documentation and/or other materials provided with the distribution.
;; 3. Neither the name of the author nor the names of its
;;    contributors may be used to endorse or promote products derived
;;    from this software without specific prior written permission.
;;
;; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
;; "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
;; LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
;; FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
;; COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
;; INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
;; (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
;; SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
;; HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
;; STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
;; ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
;; OF THE POSSIBILITY OF SUCH DAMAGE.
;;
;; Please report bugs and suggestions to arthurmaciel at gmail dot com

(module memoize
 (memoize)

 (import chicken scheme extras)
 (use srfi-69)

 (define not-found (list 'not-found))

 (define (delete-random-key! cache)
   (let* ((keys (hash-table-keys cache))
	  (random-key (random (hash-table-size cache))))
     (hash-table-delete! cache
			 (list-ref keys random-key))))

 (define (memoize proc #!optional limit)
   (let ((cache (make-hash-table)))
     (lambda args
       (let ((results (hash-table-ref/default cache args not-found)))
	 (cond ((eq? results not-found)
		(let ((results (call-with-values 
				   (lambda () (apply proc args))
				   list)))
		  ;; Avoid a huge cache by deleting random keys if limit is determined. 
		  (and limit (>= (hash-table-size cache) limit) (delete-random-key! cache))
		  (hash-table-set! cache args results)
		  (apply values results)))
	       (else
		(apply values results)))))))

 ) ;; End of module memoize
