import java.io.*;

class BWT{
	class TreeNode {
		int num;
		String item;
		TreeNode left;
		TreeNode right;
		TreeNode(String getstring){
			item=getstring;
		}
	}
static TreeNode root;
	static boolean treeContains(TreeNode node,String item){
		if(node==null) return false;
		else if(item.equals(node.item)) return true;
		else if(item.compareTo(node.item)<0) return treeContains(node.left,item);
		else return treeContains(node.right,item);
	}
	static boolean treeContainsNR(TreeNode root,String item){
		TreeNode runner;
		runner = root;
		while(true){
			if (runner==null) return false;
			else if(item.equals(runner.item)) return true;
			else if(item.compareTo(runner.item)<0) runner=runner.left;
			else runner=runner.right;
		}
	}
	static void treeInsert(String newItem){
		if(root==null){
			TreeNode root;
			root=newItem;
			return;
		}
		TreeNode runner;
		runner=root;
		while(true){
			if(newItem.compareTo(runner.item)<0){
				if(runner.left==null){
					runner.left=new TreeNode(newItem);
					return;
				}
			}else{
				if(runner.right==null){
					runner.right=new TreeNode(newItem);
					return;
				}else runner=runner.right;
			}
		}
	}

		
	public static void main(String args[]) throws Exception{
		int wordlen=args[0].length(),temp;
		String getword[][]=new String[8][2],Inword=args[0];
		for(temp=0;temp<wordlen;temp++){
			getword[temp][0]=Integer.toString(temp);
			getword[temp][1]=Inword;
			Inword=Inword.substring(1)+Inword.substring(0,1);
		}
		for(temp=0;temp<wordlen;temp++){
			System.out.println(getword[temp][0]+" : "+getword[temp][1]);
		}
	}
}
