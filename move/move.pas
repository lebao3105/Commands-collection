(* Thanks to dolev9 user from https://programmersheaven.com/ for this program! *)
program move;
uses dos,crt;

var
oldf,newf : file;
size : longint;
buffer : array[1..1000]of byte;

begin
if (ParamCount = 0) or (ParamCount = 1) then begin writeln('Missing file or folder(s).'); exit end
else
assign(oldf, ParamStr(1));
assign(newf, ParamStr(2));
reset(oldf);
rewrite(newf);


size := filesize(oldf);
while size >= 1000 do
begin
blockread(oldf,buffer,sizeof(buffer));
blockwrite(newf,buffer,sizeof(buffer));
dec(size,1000);
end;

blockread(oldf,buffer,size);
blockwrite(newf,buffer,size);

close(oldf);
close(newf);

erase(oldf);

end.