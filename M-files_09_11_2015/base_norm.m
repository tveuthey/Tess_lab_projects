
function [out] = base_norm(sig)

out=sig;
out=out-mean(out);
out=out/(std(out));
