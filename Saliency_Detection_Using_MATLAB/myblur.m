function Out = myblur(In)

In = double(In);

L1 = In(:,:,1);
a1 = In(:,:,2);
b1 = In(:,:,3);

k=[1/16 1/4 6/16 1/4 1/16];
l1=imfilter(L1,k);
l2=imfilter(l1,k');
A1=imfilter(a1,k);
A2=imfilter(A1,k');
B1=imfilter(b1,k);
B2=imfilter(B1,k');

Out(:,:,1) = l2;
Out(:,:,2) = A2;
Out(:,:,3) = B2;
