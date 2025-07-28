// prisma/seed.ts
import { PrismaClient } from '@prisma/client';
import bcrypt from 'bcrypt';

const prisma = new PrismaClient();

async function main() {
  const adminEmail = 'admin@fishing.com';
  const adminExists = await prisma.user.findUnique({
    where: { email: adminEmail },
  });

  if (!adminExists) {
    const hashedPassword = await bcrypt.hash('admin123', 10);

    await prisma.user.create({
      data: {
        name: 'Admin',
        email: adminEmail,
        password: hashedPassword,
        isAdmin: true,
        phone: null,
        location: 'HQ',
      },
    });

    console.log('✅ Admin user created');
  } else {
    console.log('ℹ️ Admin user already exists');
  }
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(() => prisma.$disconnect());
