function test(n)
  if n&1==1 then
    return 0
  else
    return 1
  end
end
print("enter a number:")
a=io.read("*n")
print(test(a))
print(a^2)
os.exit()
