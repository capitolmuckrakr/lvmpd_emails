import hashlib, os

def md5_for_file(filepath, block_size=2**20):
    md5 = hashlib.md5()
    with open(filepath , "rb" ) as f:
        while True:
            if os.path.getsize(filepath) < block_size:
                data = f.read()
            else:
                data = f.read(block_size)
            if not data:
                break
            md5.update(data)
        return md5.hexdigest()