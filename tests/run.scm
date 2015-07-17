(use test memoize)

(define (fact x)
  (let loop ((x x) (acc 1))
    (if (= x 0)
	acc
	(loop (- x 1) (* x acc)))))

(define memo-fact (memoize fact))

(test (fact 322) (memo-fact 322))

(test-exit)
