/* Layout */
import Layout from "@/views/layout/Layout";
export function vadRouterList() {
  return [
    /* route */
    // {
    //   path: "/system",
    //   component: Layout,
    //   redirect: "admin",
    //   meta: {
    //     roles: ["superadmin"]
    //   },
    //   children: [
    //     {
    //       path: "admin",
    //       component: () => import("@/vad-pages/adminManage.vue"),
    //       name: "admin",
    //       meta: {
    //         title: "管理员",
    //         icon: "lock",
    //         noCache: true,
    //         roles: ["superadmin"]
    //       }
    //     }
    //   ]
    // },
  ];
}
